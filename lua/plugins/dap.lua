-- lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dapui = require("dapui")
          dapui.setup({
            expand_lines = true,
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = { expand = { "<CR>", "<2-LeftMouse>" }, open = "o", remove = "d", edit = "e", repl = "r", toggle = "t" },
            layouts = {
              { elements = { { id = "scopes", size = 0.35 }, { id = "breakpoints", size = 0.20 }, { id = "stacks", size = 0.25 }, { id = "watches", size = 0.20 }, }, size = 40, position = "left" },
              { elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 }, }, size = 0.25, position = "bottom" },
            },
            floating = { max_height = nil, max_width = nil, border = "rounded", mappings = { close = { "q", "<Esc>" } } },
            windows = { indent = 1 },
            render = { max_type_length = nil, max_value_lines = 100 }
          })
          local dap_listeners = require("dap") 
          dap_listeners.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
          dap_listeners.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { commented = false },
      },
    },
    config = function()
      local dap = require("dap") 

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          stopOnEntry = false,
        },
      }

      -- >>> INICIO: MAPEOS PARA NVIM-DAP (MOVIDOS AQUÍ) <<<
      local dapui_ok, dapui = pcall(require, "dapui")

      vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = "DAP: Continue (<F5>)" })
      vim.keymap.set('n', '<leader>do', function() dap.step_over() end, { desc = "DAP: Step Over (<F10>)" })
      vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = "DAP: Step Into (<F11>)" })
      vim.keymap.set('n', '<leader>du', function() dap.step_out() end, { desc = "DAP: Step Out (Shift+<F11>)" })
      vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = "DAP: Toggle Breakpoint" })
      vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "DAP: Set Conditional Breakpoint" })
      vim.keymap.set('n', '<leader>dlp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "DAP: Set Log Point" })
      vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, { desc = "DAP: Open REPL" })
      vim.keymap.set('n', '<leader>dj', function() dap.run_last() end, { desc = "DAP: Run Last Config (Jump to)" })
      vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, { desc = "DAP: Terminate Session" })

      if dapui_ok then
        vim.keymap.set('n', '<leader>duu', function() dapui.toggle({}) end, { desc = "DAP: Toggle UI" })
        vim.keymap.set('n', '<leader>due', function() dapui.eval(vim.fn.input("Eval: ")) end, { desc = "DAP: Evaluate Expression (Input)"})
        vim.keymap.set('v', '<leader>due', function() dapui.eval() end, { desc = "DAP: Evaluate Visual Selection" })
        vim.keymap.set('n', '<leader>dus', function() dapui.open({reset=true}) end, { desc = "DAP: Open UI (Scopes)"})
      else
        vim.keymap.set({'n', 'v'}, '<leader>due', function() require('dap.ui.widgets').hover() end, { desc = "DAP: Hover/Evaluate (Fallback)" })
      end

      vim.keymap.set('n', '<leader>dsc', function()
        local configs = {}
        for _, config_type_table in pairs(dap.configurations) do
          if type(config_type_table) == "table" then
            for _, config_entry in ipairs(config_type_table) do
              table.insert(configs, config_entry.name .. " (type: " .. config_entry.type .. ")")
            end
          end
        end
        if #configs == 0 then vim.notify("DAP: No configurations found.", vim.log.levels.WARN); return end
        vim.ui.select(configs, { prompt = "Select DAP configuration:" }, function(choice)
          if not choice then return end
          local selected_name = string.match(choice, "^(.-)%s*%(")
          for _, config_type_table in pairs(dap.configurations) do
            if type(config_type_table) == "table" then
              for _, config_entry in ipairs(config_type_table) do
                if config_entry.name == selected_name then dap.run(config_entry); return end
              end
            end
          end
        end)
      end, { desc = "DAP: Select Configuration and Run" })
      -- >>> FIN: MAPEOS PARA NVIM-DAP <<<
      
      vim.notify("nvim-dap configurado y mapeos aplicados.", vim.log.levels.INFO, {title = "DAP Setup"})
    end,
  },
}
