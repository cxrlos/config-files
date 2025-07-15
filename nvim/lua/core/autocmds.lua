-- ===================================================================
--                        CORE AUTOCMDS
-- ===================================================================
-- Filetype-specific settings and automatic commands
-- Cursor-compatible autocommands
-- ===================================================================

-- ===================================================================
-- FILETYPE-SPECIFIC SETTINGS
-- ===================================================================

-- Text and documentation files
vim.cmd([[
    augroup filetypes
        autocmd!
        autocmd FileType tex,markdown,text setlocal wrap
        autocmd FileType tex,markdown,text setlocal linebreak
        autocmd FileType tex,markdown,text setlocal spell
        autocmd FileType tex,markdown,text setlocal spelllang=en_us
    augroup END
]])

-- Programming languages
vim.cmd([[
    augroup filetypes
        autocmd!
        autocmd FileType python setlocal tabstop=4 shiftwidth=4
        autocmd FileType javascript,typescript setlocal tabstop=2 shiftwidth=2
        autocmd FileType lua setlocal tabstop=2 shiftwidth=2
    augroup END
]])

-- ===================================================================
-- BUFFER AND EDITOR BEHAVIOR
-- ===================================================================

-- Highlight yanked text and auto-resize windows
vim.cmd([[
    augroup buffer_settings
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=300}
        autocmd VimResized * wincmd =
    augroup END
]])

-- ===================================================================
-- END OF AUTOCMDS
-- ===================================================================
