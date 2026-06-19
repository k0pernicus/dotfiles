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
-- vim.cmd("set textwidth=80")
vim.cmd("set colorcolumn=+1")
vim.cmd("set scrolloff=999")
-- vim.cmd("autocmd FileType * set colorcolumn=120")
vim.cmd("autocmd FileType python set colorcolumn=80")
vim.cmd("set clipboard+=unnamedplus")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.g.maplocalleader = "\\"

-- Buffer management (b = buffer)
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bl", ":buffers<CR>", { desc = "List buffers" })
vim.keymap.set("n", "<leader>bN", ":enew<CR>", { desc = "New buffer" })

-- Tab management (t = tab)
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", ":tabprev<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tl", ":tabs<CR>", { desc = "List tabs" })
vim.keymap.set("n", "<leader>tN", ":tabnew<CR>", { desc = "New tab" })

-- Window navigation (w = window)
vim.keymap.set("n", "<leader>w<Left>", "<C-w>h", { remap = true, desc = "Move to left split" })
vim.keymap.set("n", "<leader>w<Down>", "<C-w>j", { remap = true, desc = "Move to bottom split" })
vim.keymap.set("n", "<leader>w<Up>", "<C-w>k", { remap = true, desc = "Move to top split" })
vim.keymap.set("n", "<leader>w<Right>", "<C-w>l", { remap = true, desc = "Move to right split" })

-- Window resizing (w = window)
vim.keymap.set("n", "<leader>w+", ":resize +3<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>w-", ":resize -3<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>w>", ":vertical resize +3<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader>w<", ":vertical resize -3<CR>", { desc = "Decrease window width" })

-- Window splitting (w = window)
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split below (horizontal)" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split right (vertical)" })
vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "Close split" })

-- Terminal in splits (w = window)
vim.keymap.set("n", "<leader>wt", ":term<CR>", { desc = "Terminal (horizontal)" })
vim.keymap.set("n", "<leader>wT", ":vert term<CR>", { desc = "Terminal (vertical)" })

-- Exit terminal mode with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.opt.encoding = "utf-8"
vim.g.have_nerd_font = true -- Tells plugins you have a Nerd Font installed

vim.diagnostic.config({
	virtual_text = true, -- Shows the error message at the end of the line
	signs = true, -- Keeps the 'E' in the gutter
	update_in_insert = false, -- Don't show errors while you are still typing
	underline = true, -- Underline the actual code that is broken
	severity_sort = true,
})

-- OCaml-specific settings (2 spaces indentation)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "ocaml",
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.shiftwidth = 2
	end,
})

require("config.lazy")
