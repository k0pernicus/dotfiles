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
                ensure_installed = { "rust_analyzer", "clangd" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config('clangd', {
                filetypes = {"c", "cpp", "h", "hpp"}
            })
            vim.lsp.enable('clang')

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'cd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'cD', vim.lsp.buf.declaration, {})
            vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
        end
    }
}
