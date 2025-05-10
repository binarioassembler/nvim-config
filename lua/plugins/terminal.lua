-- ~/.config/nvim/lua/plugins/terminal.lua
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
        return math.floor(vim.o.lines * 0.6)
      end,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = '75', -- Un valor más alto oscurece más los terminales inactivos
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      winbar = {
        enabled = false,
      },
      float_opts = {
        border = 'curved', -- O 'rounded', 'curved', 'single', etc.
        title = "Salida del Comando",
        title_pos = "center",
        width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        -- Referenciar los grupos de resaltado definidos en colorscheme.lua
        highlights = {
          border = "ToggleTermBorder",
          background = "ToggleTermFloatBg", -- Este será el fondo de la VENTANA flotante
          title = "ToggleTermTitle",
        },
      },
    },
    -- No es necesario un 'config' aquí si solo estamos usando 'opts'
    -- y los resaltados se definen externamente.
    -- Si la integración de Catppuccin para toggleterm (en colorscheme.lua) funciona,
    -- incluso podrías eliminar la sección 'highlights' de aquí y dejar que Catppuccin lo maneje.
  },
}
