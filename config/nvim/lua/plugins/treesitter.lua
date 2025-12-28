return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {'c', 'cpp', 'lua', 'odin', 'markdown'},
	        highlight = {enable = true},
	        indent = {enable = true},
	    })
    end
}
