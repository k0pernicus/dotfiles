return {
	"kdheepak/lazygit.nvim",
	cmd = "LazyGit",
	-- optional for floating window border decoration
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open lazygit" })
	end,
}
