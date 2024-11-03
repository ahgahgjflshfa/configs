return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        -- 設定調試相關的字符和顏色
        local dap_breakpoint_color = {
            breakpoint = {
                ctermbg = 0,
                fg = '#993939',
                bg = '#31353f',
            },
            logpoint = {
                ctermbg = 0,
                fg = '#61afef',
                bg = '#31353f',
            },
            stopped = {
                ctermbg = 0,
                fg = '#98c379',
                bg = '#31353f'
            },
        }

        vim.api.nvim_set_hl(0, 'DapBreakpoint', dap_breakpoint_color.breakpoint)
        vim.api.nvim_set_hl(0, 'DapLogPoint', dap_breakpoint_color.logpoint)
        vim.api.nvim_set_hl(0, 'DapStopped', dap_breakpoint_color.stopped)

        local dap_breakpoint = {
            error = {
                text = "",
                texthl = "DapBreakpoint",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            },
            condition = {
                text = '',
                texthl = 'DapBreakpoint',
                linehl = 'DapBreakpoint',
                numhl = 'DapBreakpoint',
            },
            rejected = {
                text = "",
                texthl = "DapBreakpoint",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            },
            logpoint = {
                text = '',
                texthl = 'DapLogPoint',
                linehl = 'DapLogPoint',
                numhl = 'DapLogPoint',
            },
            stopped = {
                text = '',
                texthl = 'DapStopped',
                linehl = 'DapStopped',
                numhl = 'DapStopped',
            },
        }

        vim.fn.sign_define('DapBreakpoint', dap_breakpoint.error)
        vim.fn.sign_define('DapBreakpointCondition', dap_breakpoint.condition)
        vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
        vim.fn.sign_define('DapLogPoint', dap_breakpoint.logpoint)
        vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)

        -- Cpp debugger
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command =
            'C:\\Users\\mailt\\AppData\\Local\\nvim-data\\dap\\cppdap\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
            options = {
                detached = false
            },
        }
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopAtEntry = true,
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'enable pretty printing',
                        ignoreFailures = false
                    },
                },
            },
            {
                name = 'Attach to gdbserver :1234',
                type = 'cppdbg',
                request = 'launch',
                MIMode = 'gdb',
                miDebuggerServerAddress = 'localhost:1234',
                miDebuggerPath = 'C:\\msys64\\ucrt64\\bin\\gdb.exe',
                cwd = '${workspaceFolder}',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '\\', 'file')
                end,
            },
        }

        -- Debugger UI
        dapui.setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
        vim.keymap.set('n', '<Leader>dc', dap.continue, {})
        vim.keymap.set('n', '<Leader>dq', function()
            dap.terminate()
            dapui.close()
        end, { desc = "Quit DAP and close UI" })
    end,
}
