-- vim.cmd("set autochdir")
vim.cmd("set autoindent")
vim.cmd("set encoding=utf-8")
vim.cmd("set hlsearch")
vim.cmd("set noerrorbells")
vim.cmd("set number")
vim.cmd("set ruler")
vim.cmd("set showcmd")
vim.cmd("set smartindent")
vim.cmd("set mouse= ")
vim.cmd("set ignorecase")
vim.cmd("set incsearch")
vim.cmd("set backspace=indent,eol,start")

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set textwidth=80")
vim.cmd("set colorcolumn=+1")
vim.cmd("set scrolloff=999")
vim.cmd("autocmd FileType * set colorcolumn=120")
vim.cmd("autocmd FileType python set colorcolumn=80")

vim.g.mapleader = ";"
-- vim.g.maplocalleader = "\\"

vim.keymap.set('n', 'bb', ':bnext<CR>')
vim.keymap.set('n', 'bB', ':bprev<CR>')
vim.keymap.set('n', 'bd', ':bdelete<CR>')
--vim.keymap.set('n', '<C-S-Left>', ':bprev<CR>')
--vim.keymap.set('n', '<C-S-Right>', ':bnext<CR>')
vim.keymap.set('n', '<C-Left>', '<C-W><C-H>')
vim.keymap.set('n', '<C-Down>', '<C-W><C-J>')
vim.keymap.set('n', '<C-Up>', '<C-W><C-K>')
vim.keymap.set('n', '<C-Right>', '<C-W><C-L>')
vim.keymap.set('n', '<M-Up>', ':resize -3<CR>')
vim.keymap.set('n', '<M-Down>', ':resize +3<CR>')
vim.keymap.set('n', '<M-S-Up>', ':vertical resize -3<CR>')
vim.keymap.set('n', '<M-S-Down>', ':vertical resize +3<CR>')


-- nnoremap <C-N> :bprev<CR> " previous buffer
-- nnoremap <C-n> :bnext<CR> " next buffer
-- nnoremap <C-b> :bdelete<CR> " delete the current buffer
-- nnoremap <C-H> <C-W><C-H> " go to left
-- nnoremap <C-J> <C-W><C-J> " go to down
-- nnoremap <C-K> <C-W><C-K> " go to up
-- nnoremap <C-L> <C-W><C-L> " go to right

require("config.lazy")
