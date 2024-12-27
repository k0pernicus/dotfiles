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

vim.g.mapleader = ","
-- vim.g.maplocalleader = "\\"

require("config.lazy")
