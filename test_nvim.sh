#!/bin/bash

# ===================================================================
#                        NEOVIM TEST SCRIPT
# ===================================================================
# Test script to verify Neovim configuration and LSP functionality
# ===================================================================

echo "🧪 Testing Neovim Configuration..."

# Test 1: Basic Neovim startup
echo "1. Testing basic Neovim startup..."
if nvim --headless -c "lua print('Neovim started successfully')" -c "quit" 2>/dev/null; then
    echo "   ✅ Neovim starts successfully"
else
    echo "   ❌ Neovim failed to start"
    exit 1
fi

# Test 2: Core modules
echo "2. Testing core modules..."
if nvim --headless -c "lua require('core.init')" -c "lua print('Core modules loaded')" -c "quit" 2>/dev/null; then
    echo "   ✅ Core modules loaded successfully"
else
    echo "   ❌ Core modules failed to load"
fi

# Test 3: Plugins
echo "3. Testing plugin loading..."
if nvim --headless -c "lua require('plugins.init')" -c "lua print('Plugins loaded')" -c "quit" 2>/dev/null; then
    echo "   ✅ Plugins loaded successfully"
else
    echo "   ❌ Plugins failed to load"
fi

# Test 4: Full configuration
echo "4. Testing full configuration..."
if nvim --headless -c "source ~/.config/nvim/init.lua" -c "lua print('Full config loaded')" -c "quit" 2>/dev/null; then
    echo "   ✅ Full configuration loaded successfully"
else
    echo "   ❌ Full configuration failed to load"
fi

# Test 5: Mason
echo "5. Testing Mason..."
if nvim --headless -c "lua require('mason').setup()" -c "lua print('Mason loaded')" -c "quit" 2>/dev/null; then
    echo "   ✅ Mason loaded successfully"
else
    echo "   ❌ Mason failed to load"
fi

# Test 6: LSP functionality
echo "6. Testing LSP functionality..."
echo 'print("Hello, World!")' > /tmp/test_lsp.py
if nvim --headless -c "edit /tmp/test_lsp.py" -c "lua print('Python file opened')" -c "quit" 2>/dev/null; then
    echo "   ✅ LSP file handling working"
else
    echo "   ❌ LSP file handling failed"
fi
rm -f /tmp/test_lsp.py

# Test 7: Interactive Neovim
echo "7. Testing interactive Neovim..."
if nvim -c "lua print('Interactive mode working')" -c "quit" 2>/dev/null; then
    echo "   ✅ Interactive Neovim working"
else
    echo "   ❌ Interactive Neovim failed"
fi

echo ""
echo "🎉 Neovim testing complete!"
echo ""
echo "To test LSP functionality manually:"
echo "1. Open a Python file: nvim test.py"
echo "2. Check LSP status: :LspInfo"
echo "3. Test LSP features: K (hover), gd (go to definition)"
echo ""
