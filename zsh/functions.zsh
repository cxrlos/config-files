# ===================================================================
# FUNCTIONS CONFIGURATION
# ===================================================================

# Git checkout new branch with conventional commits style
gconb() {
    # Help flag
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Git Conventional Branch Creator (gconb)"
        echo "======================================"
        echo ""
        echo "Usage: gconb <type> <description>"
        echo "       gconb --help"
        echo ""
        echo "Description:"
        echo "  Creates a new git branch with conventional commit naming."
        echo "  Format: YYYY-MM-DD/type/description"
        echo ""
        echo "Types:"
        echo "  feat     - New feature"
        echo "  fix      - Bug fix"
        echo "  docs     - Documentation changes"
        echo "  style    - Code style changes (formatting, etc.)"
        echo "  refactor - Code refactoring"
        echo "  test     - Adding or updating tests"
        echo "  chore    - Maintenance tasks"
        echo ""
        echo "Examples:"
        echo "  gconb feat user-authentication"
        echo "  gconb fix login-error"
        echo "  gconb docs api-documentation"
        echo "  gconb refactor database-query"
        echo "  gconb test unit-tests"
        echo "  gconb chore dependency-update"
        echo ""
        echo "Branch Naming:"
        echo "  Input:  gconb feat user-auth"
        echo "  Output: 2024-01-15/feat/user-auth"
        echo ""
        echo "Safety Features:"
        echo "  ✓ Validates git repository"
        echo "  ✓ Checks for uncommitted changes"
        echo "  ✓ Validates conventional commit types"
        echo "  ✓ Provides clear error messages"
        echo ""
        echo "Quick Aliases (optional):"
        echo "  gbf  - gconb feat"
        echo "  gbb  - gconb fix"
        echo "  gbd  - gconb docs"
        echo "  gbr  - gconb refactor"
        echo "  gbt  - gconb test"
        echo "  gbc  - gconb chore"
        return 0
    fi

    local type=${1:-feature}
    local description=${2:-}
    
    if [ -z "$description" ]; then
        echo "Usage: gconb <type> <description>"
        echo "       gconb --help"
        echo ""
        echo "Types:"
        echo "  feat     - New feature"
        echo "  fix      - Bug fix"
        echo "  docs     - Documentation changes"
        echo "  style    - Code style changes (formatting, etc.)"
        echo "  refactor - Code refactoring"
        echo "  test     - Adding or updating tests"
        echo "  chore    - Maintenance tasks"
        echo ""
        echo "Examples:"
        echo "  gconb feat user-authentication"
        echo "  gconb fix login-error"
        echo "  gconb docs api-documentation"
        echo "  gconb refactor database-query"
        return 1
    fi

    # Validate conventional commit type
    case $type in
        feat|fix|docs|style|refactor|test|chore) ;;
        *) 
            echo "❌ Invalid type: $type" >&2
            echo "Valid types: feat, fix, docs, style, refactor, test, chore" >&2
            return 1 
            ;;
    esac

    # Validate git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Error: Not in a git repository" >&2
        return 1
    fi

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        echo "⚠️  Warning: You have uncommitted changes. Continue? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Branch creation cancelled."
            return 1
        fi
    fi

    local date=$(date +%Y-%m-%d)
    local branch_name="${date}/${type}/${description// /-}"

    # Create and checkout branch
    if git checkout -b "$branch_name"; then
        echo "✅ Created and switched to branch: $branch_name"
        echo "📝 Type: $type"
        echo "📅 Date: $date"
    else
        echo "❌ Failed to create branch" >&2
        return 1
    fi
}

# Quick directory navigation
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract function for various archive types
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

 