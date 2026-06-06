return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add          = { text = "+" },
				change       = { text = "~" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
			},
			signcolumn = true,
			numhl      = false,
			linehl      = false,
			word_diff  = false,
		})
		-- Git diff keymaps
		vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<CR>", { desc = "Git diff current file" })
		vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Git blame current line" })
		vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
		vim.keymap.set("n", "<leader>gn", function() require("gitsigns").next_hunk({ buffer = 0 }) end, { desc = "Next git hunk" })
		vim.keymap.set("n", "<leader>gp", function() require("gitsigns").prev_hunk({ buffer = 0 }) end, { desc = "Previous git hunk" })
	end,
}
