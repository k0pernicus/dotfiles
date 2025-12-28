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
-- Using lowercase h, j, k, l is standard practice
vim.keymap.set('n', '<C-Left>', '<C-w>h', { remap = true; desc = 'Move to left split' })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { remap = true; desc = 'Move to bottom split' })
vim.keymap.set('n', '<C-Up>', '<C-w>k', { remap = true; desc = 'Move to top split' })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { remap = true; desc = 'Move to right split' })
vim.keymap.set('n', '<M-Up>', ':resize -3<CR>')
vim.keymap.set('n', '<M-Down>', ':resize +3<CR>')
vim.keymap.set('n', '<M-S-Up>', ':vertical resize -3<CR>')
vim.keymap.set('n', '<M-S-Down>', ':vertical resize +3<CR>')

vim.opt.encoding = "utf-8"
vim.g.have_nerd_font = true -- Tells plugins you have a Nerd Font installed

require("config.lazy")
