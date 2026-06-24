return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"gopls",
					"lua_ls",
					"rust_analyzer",
					"ocamllsp",
					"zls",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"codelldb",
					"stylua",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Configure clangd to only output actual errors to stderr (silencing info/debug spam)
			vim.lsp.config("clangd", {
				cmd = { "clangd", "--log=error" },
			})

			-- Configure sourcekit to use xcrun to locate sourcekit-lsp on macOS
			vim.lsp.config("sourcekit", {
				cmd = { "xcrun", "sourcekit-lsp" },
			})

			-- Configure lua_ls settings
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- Configure nixd settings
			vim.lsp.config("nixd", {
				settings = {
					nixd = {
						formatting = { command = { "nixfmt" } },
					},
				},
			})

			-- Enable the language servers (using the new Neovim 0.11 API)
			vim.lsp.enable("clangd")
			vim.lsp.enable("gopls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("nixd")
			vim.lsp.enable("ocamllsp")
			vim.lsp.enable("rust_analyzer")
			vim.lsp.enable("sourcekit")

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.server_capabilities.completionProvider then
						-- This enables <Ctrl-x><Ctrl-o> for completion
						vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					end
				end,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
			vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code actions" })
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP rename" })
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP format" })
		end,
	},
}
