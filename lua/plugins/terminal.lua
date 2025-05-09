-- ~/.config/nvim/lua/plugins/terminal.lua
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*", -- o una versión específica si prefieres
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15 -- Altura para splits horizontales
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4 -- Ancho para splits verticales
        end
        return 20 -- Tamaño para terminales flotantes (altura si es flotante por defecto)
      end,
      open_mapping = [[<c-t>]], -- Atajo para abrir un terminal genérico (Ctrl + t)
      hide_numbers = true,       -- Ocultar números de línea en el terminal
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 1, -- Un poco menos de sombreado que el valor por defecto
      start_in_insert = true,
      insert_mappings = true, -- Permite usar mapeos de inserción en el terminal
      persist_size = true,
      direction = 'float', -- Por defecto, los terminales se abrirán como flotantes
      close_on_exit = true, -- Cerrar la ventana del terminal cuando el proceso termine
      shell = vim.o.shell, -- Usar el shell configurado en Neovim
      float_opts = {
        border = 'curved', -- Tipo de borde para terminales flotantes
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      -- Mapeos de ventana para cerrar el terminal flotante
      -- Puedes usar 'q' en modo normal o <Esc> en modo terminal para cerrar
      winbar = {
        enabled = false, -- Deshabilitar la winbar para toggleterm si no la usas
      },
    },
    -- Configuración opcional, puedes añadir mapeos de teclas aquí si lo prefieres globalmente
    -- config = function(_, opts)
    --   require('toggleterm').setup(opts)
    --   -- Ejemplo de mapeo global para un terminal flotante
    --   -- vim.keymap.set('n', '<leader>tf', "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal flotante" })
    -- end,
  },
}
