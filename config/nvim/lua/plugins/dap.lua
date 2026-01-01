return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio", -- Required for dap-ui
    },

    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        dapui.setup()
        -- Automatically open the UI when debugging starts
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        -- Automatically close it when debugging ends
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        dap.adapters.codelldb = {
            type = 'executable',
            command = 'codelldb',
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

        vim.keymap.set('n', '<F5>', dap.continue)
        vim.keymap.set('n', '<F10>', dap.step_over)
        vim.keymap.set('n', '<F11>', dap.step_into)
        vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)

        -- Forcefully stop the debugger and the program being debugged
        vim.keymap.set('n', '<leader>dq', function()
            require('dap').terminate()
            require('dap').close()
            print("Debugger Terminated")
        end, { desc = "Debug: Stop/Terminate" })


        dap.configurations.odin = config
        dap.configurations.c = config
        dap.configurations.cpp = config
        dap.configurations.rust = config

        -- This function runs every time a debug session starts
        -- dap.listeners.after.event_initialized["auto_output"] = function()
        --    vim.cmd("vsplit")
        --    vim.cmd("term tail -f debug.log")
        --    vim.cmd("wincmd p")
        -- end

        -- Cleanup: Close the log window when the debugger stops
        dap.listeners.after.event_terminated["auto_output"] = function()
            print("Debug Session Ended. Log window remains open.")
        end
    end
}
