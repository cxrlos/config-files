syntax on

let mapleader = " "
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set backspace=indent,eol,start
set number relativenumber
set nu rnu
set encoding=UTF-8
set laststatus=2
set autoread
au FocusGained,BufEnter * checktime

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

set nocompatible

set ignorecase
set smartcase
set hlsearch
set incsearch
set magic

call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'
Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
Plug 'github/copilot.vim'
Plug 'preservim/nerdtree'
Plug 'alvan/vim-closetag'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
call plug#end()

colorscheme gruvbox

let g:closetag_filenames = '*.html,*.xhtml,*.phtml, *.js, *.jsx'

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>

inoremap (; (<CR>);<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [, [<CR>],<C-c>O

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>
