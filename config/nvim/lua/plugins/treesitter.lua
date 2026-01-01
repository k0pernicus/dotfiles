return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {'c', 'cpp', 'lua', 'odin', 'markdown', 'vimdoc', 'query'},
	        highlight = {enable = true},
	        indent = {enable = true},
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Leader>ss", -- Start selection
                    node_incremental = "<Leader>si", -- Increment to the next scope
                    scope_incremental = "<Leader>sc", -- Increment to the whole scope
                    node_decremental = "<Leader>sd" -- Shrink selection
                }
            }
	    })
    end
}
