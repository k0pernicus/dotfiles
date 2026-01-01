return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "rust_analyzer",
                    "clangd",
                    "gopls",
                    "lua_ls",
                    "pyright"
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.enable('clangd')
            vim.lsp.enable('rust_analyzer')
            vim.lsp.enable('gopls')
            vim.lsp.enable('pyright')
            vim.lsp.enable('ols')
            vim.lsp.enable('lua_ls')

            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
        end
    }
}
