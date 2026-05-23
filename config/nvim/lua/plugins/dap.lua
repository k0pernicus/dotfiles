return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio", -- Required for dap-ui
        "mfussenegger/nvim-dap-python",
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
        -- Map "swift" and "lldb" adapter names to codelldb (so VSCode launch.json configs work)
        dap.adapters.swift = dap.adapters.codelldb
        dap.adapters.lldb = dap.adapters.codelldb

        -- Helper function to find compiled executable binaries in a given directory
        local function get_binaries_in_dir(dir)
            local binaries = {}
            local handle = vim.uv.fs_scandir(dir)
            if handle then
                while true do
                    local name, type = vim.uv.fs_scandir_next(handle)
                    if not name then break end
                    local filepath = dir .. "/" .. name
                    -- Filter out directories, hidden files, and debug symbol files (.d)
                    if type == "file" and vim.fn.executable(filepath) == 1 and not name:match("%.d$") then
                        table.insert(binaries, filepath)
                    end
                end
            end
            return binaries
        end

        -- Factory to create an auto-detect launch configuration
        local function make_auto_launch_config(default_dir, prompt_name)
            return {
                name = "Launch " .. prompt_name .. " Target (Auto-detect)",
                type = "codelldb",
                request = "launch",
                program = function()
                    local dir = vim.fn.expand(default_dir)
                    local binaries = get_binaries_in_dir(dir)

                    if #binaries == 1 then
                        return binaries[1]
                    elseif #binaries > 1 then
                        local co = coroutine.running()
                        if co then
                            vim.ui.select(binaries, {
                                prompt = "Select " .. prompt_name .. " binary:",
                                format_item = function(item)
                                    return vim.fn.fnamemodify(item, ":t")
                                end,
                            }, function(choice)
                                coroutine.resume(co, choice)
                            end)
                            return coroutine.yield()
                        end
                    end
                    return vim.fn.input("Path to executable: ", dir .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
            }
        end

        -- Factory to create a launch configuration with arguments
        local function make_arg_launch_config(default_dir, prompt_name)
            local cfg = make_auto_launch_config(default_dir, prompt_name)
            cfg.name = "Launch " .. prompt_name .. " Target (With Arguments)"
            cfg.args = function()
                local args_str = vim.fn.input("Arguments: ")
                return vim.split(args_str, " +")
            end
            return cfg
        end

        -- General fallback configurations for C/C++ (where build systems vary)
        local fallback_config = {
            {
                name = "Launch Binary",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
            },
            {
                name = "Launch Binary (With Arguments)",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                args = function()
                    local args_str = vim.fn.input("Arguments: ")
                    return vim.split(args_str, " +")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            }
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

        dap.configurations.swift = {
            make_auto_launch_config("${workspaceFolder}/.build/debug", "Swift"),
            make_arg_launch_config("${workspaceFolder}/.build/debug", "Swift"),
        }

        dap.configurations.rust = {
            make_auto_launch_config("${workspaceFolder}/target/debug", "Rust"),
            make_arg_launch_config("${workspaceFolder}/target/debug", "Rust"),
        }

        dap.configurations.c = fallback_config
        dap.configurations.cpp = fallback_config

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

        -- Setup Python debugging adapter
        -- Look for a local .venv first, otherwise fallback to python3/python
        local venv_python = vim.fn.getcwd() .. '/.venv/bin/python'
        local venv_python3 = vim.fn.getcwd() .. '/.venv/bin/python3'

        if vim.fn.executable(venv_python) == 1 then
            require('dap-python').setup(venv_python)
        elseif vim.fn.executable(venv_python3) == 1 then
            require('dap-python').setup(venv_python3)
        else
            -- Always fallback to python3 to avoid macOS xcode-select python stub
            require('dap-python').setup('python3')
        end

        -- Load launch.json if it exists in the workspace
        require('dap.ext.vscode').load_launchjs(nil, { codelldb = {'c', 'cpp', 'rust', 'swift'}, python = {'python'} })
    end
}
