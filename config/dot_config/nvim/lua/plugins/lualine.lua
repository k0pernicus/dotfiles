return {
    "nvim-lualine/lualine.nvim",
    config = function ()
        require('lualine').setup({
            options = {
                theme = "palenight",
                icons_enabled = true,
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
            }
        })
    end
}
