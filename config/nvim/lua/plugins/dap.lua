return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require('dap')

        dap.adapters.codelldb = {
            type = 'executable',
            command = 'codelldb', -- Ensure this is in your $PATH or installed via Mason
        }

        local config = {
            {
                name = "Launch Binary",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }

        dap.configurations.odin = config
        dap.configurations.c = config
        dap.configurations.cpp = config
        dap.configurations.rust = config
    end
}
