#!/bin/bash

# Prevent Sleep Script with Battery Protection
# This script prevents sleep when lid is closed but includes safety measures

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BATTERY_THRESHOLD=20  # Percentage below which we allow sleep
IDLE_TIMEOUT=300      # 5 minutes of inactivity before allowing sleep
CHECK_INTERVAL=30     # Check every 30 seconds

# Function to get battery percentage
get_battery_percentage() {
    local battery_info=$(pmset -g batt | grep -E "([0-9]{1,3}%)" | awk '{print $3}' | sed 's/%;.*//')
    echo "${battery_info:-100}"
}

# Function to check if AC is connected
is_ac_connected() {
    local ac_status=$(pmset -g batt | grep -E "AC Power" | wc -l)
    [ "$ac_status" -gt 0 ] && return 0 || return 1
}

# Function to check if lid is closed (reliable on modern macOS)
# Uses the AppleClamshellState property, which returns "Yes" (closed) or "No" (open).
# Falls back to older detection methods if the property is not found.
is_lid_closed() {
    # Query the AppleClamshellState value (works on most modern macOS versions)
    local state=$(ioreg -r -k AppleClamshellState -d 1 | awk '/AppleClamshellState/ {print $3}')

    # Normalize the value to lowercase for comparison
    state=$(echo "$state" | tr '[:upper:]' '[:lower:]')

    # If we got a valid answer, evaluate it
    if [[ "$state" == "yes" || "$state" == "1" || "$state" == "true" ]]; then
        return 0  # Lid is closed
    elif [[ "$state" == "no" || "$state" == "0" || "$state" == "false" ]]; then
        return 1  # Lid is open
    fi

    # Fallback for older macOS versions that expose a different node
    local lid_status=$(ioreg -n AppleClamshell | grep -i "closed" | wc -l)
    [ "$lid_status" -gt 0 ] && return 0 || return 1
}

# Function to get user idle time (in seconds)
get_idle_time() {
    local idle_time=$(ioreg -n IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')
    echo "${idle_time:-0}"
}

# Function to show current status
show_status() {
    local battery=$(get_battery_percentage)
    local ac_connected=$(is_ac_connected && echo "Connected" || echo "Disconnected")
    local lid_status=$(is_lid_closed && echo "Closed" || echo "Open")
    local idle_time=$(get_idle_time)

    echo -e "${BLUE}=== Current Status ===${NC}"
    echo -e "Battery: ${battery}%"
    echo -e "AC Power: ${ac_connected}"
    echo -e "Lid: ${lid_status}"
    echo -e "Idle Time: ${idle_time}s"
    echo ""
}

# Function to enable sleep prevention
enable_sleep_prevention() {
    echo -e "${GREEN}Enabling sleep prevention...${NC}"
    sudo pmset -c disablesleep 1
    echo -e "${GREEN}Sleep prevention enabled${NC}"
}

# Function to disable sleep prevention
disable_sleep_prevention() {
    echo -e "${YELLOW}Disabling sleep prevention...${NC}"
    sudo pmset -c disablesleep 0
    echo -e "${YELLOW}Sleep prevention disabled${NC}"
}

# Function to check if sleep prevention should be active
should_prevent_sleep() {
    local battery=$(get_battery_percentage)
    local idle_time=$(get_idle_time)

    # Don't prevent sleep if battery is too low
    if [ "$battery" -lt "$BATTERY_THRESHOLD" ]; then
        echo -e "${RED}Battery too low (${battery}% < ${BATTERY_THRESHOLD}%). Allowing sleep.${NC}"
        return 1
    fi

    # Don't prevent sleep if user has been idle for too long
    if [ "$idle_time" -gt "$IDLE_TIMEOUT" ]; then
        echo -e "${YELLOW}User idle for ${idle_time}s > ${IDLE_TIMEOUT}s. Allowing sleep.${NC}"
        return 1
    fi

    # Only prevent sleep if lid is closed
    if is_lid_closed; then
        return 0
    else
        echo -e "${BLUE}Lid is open. Sleep prevention not needed.${NC}"
        return 1
    fi
}

# Function to handle cleanup on script exit
cleanup() {
    echo -e "\n${YELLOW}Cleaning up...${NC}"
    disable_sleep_prevention
    echo -e "${GREEN}Cleanup complete. Exiting.${NC}"
    exit 0
}

# Set up signal handlers for cleanup
trap cleanup SIGINT SIGTERM

# Main function
main() {
    echo -e "${BLUE}=== MacBook Sleep Prevention Script ===${NC}"
    echo -e "Battery threshold: ${BATTERY_THRESHOLD}%"
    echo -e "Idle timeout: ${IDLE_TIMEOUT}s"
    echo -e "Check interval: ${CHECK_INTERVAL}s"
    echo -e "Press Ctrl+C to exit and restore normal sleep behavior"
    echo ""

    # Check if running with sudo
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}This script must be run with sudo${NC}"
        echo "Usage: sudo ./prevent_sleep.sh"
        exit 1
    fi

    # Show initial status
    show_status

    # Main loop
    while true; do
        if should_prevent_sleep; then
            enable_sleep_prevention
        else
            disable_sleep_prevention
        fi

        # Wait before next check
        sleep "$CHECK_INTERVAL"

        # Show status every few checks
        if [ $((SECONDS % 60)) -eq 0 ]; then
            show_status
        fi
    done
}

# Run main function
main "$@"
