-- lua/plugins/dadbod.lua
return {
  {
    "tpope/vim-dadbod",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          vim.g.db_ui_use_nerd_fonts = 1
          vim.g.db_ui_show_database_icon = 1
          vim.g.db_ui_force_echo_notifications = 1

          local expanded_char = '▾'
          local collapsed_char = '▸'

          vim.g.db_ui_icons = {
            expanded = {
              db = expanded_char .. ' 󰆼',
              buffers = expanded_char .. ' ',
              saved_queries = expanded_char .. ' ',
              schemas = expanded_char .. ' ',
              schema = expanded_char .. ' 󰙅',
              tables = expanded_char .. ' 󰓱',
              table = expanded_char .. ' ',
            },
            collapsed = {
              db = collapsed_char .. ' 󰆼',
              buffers = collapsed_char .. ' ',
              saved_queries = collapsed_char .. ' ',
              schemas = collapsed_char .. ' ',
              schema = collapsed_char .. ' 󰙅',
              tables = collapsed_char .. ' 󰓱',
              table = collapsed_char .. ' ',
            },
            saved_query = '  ',
            new_query = '  󰓰',
            tables = '  󰓫',
            buffers = '  ',
            add_connection = '  󰆺',
            connection_ok = '✓',
            connection_error = '✕',
          }

          -- Leer URLs de conexión desde variables de entorno
          local connections = {}
          local pg_url = os.getenv("DB_POSTGRES_LOCAL_URL")
          local mysql_url = os.getenv("DB_MYSQL_LOCAL_URL")

          if pg_url then
            connections.postgres_local_binario = { url = pg_url }
          else
            -- Puedes mantener o quitar estas notificaciones si lo deseas
            vim.notify("Variable de entorno DB_POSTGRES_LOCAL_URL no definida.", vim.log.levels.WARN,
              { title = "Dadbod UI" })
          end

          if mysql_url then
            connections.mysql_local_root = { url = mysql_url }
          else
            vim.notify("Variable de entorno DB_MYSQL_LOCAL_URL no definida.", vim.log.levels.WARN,
              { title = "Dadbod UI" })
          end

          vim.g.db_ui_connections = connections

          vim.keymap.set("n", "<leader>dbu", "<cmd>DBUIToggle<cr>", { desc = "Toggle DB UI" })
        end,
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" }, -- Restaurado como lo tenías
        lazy = true,
      },
    },
    event = "VeryLazy",
  },
}
