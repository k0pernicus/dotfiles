return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Toggle file explorer" })
		require("neo-tree").setup({
			sources = {
				"filesystem",
				"git_status",
				"buffers",
			},
			git_status = {
				symbols = {
					added     = "✚",
					modified  = "M",
					deleted   = "✖",
					renamed   = "",
					untracked = "??",
					ignored   = "◌",
					staged    = "✓",
					conflict  = "",
				},
			},
		})
	end,
}
