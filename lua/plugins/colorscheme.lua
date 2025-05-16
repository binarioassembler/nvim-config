-- lua/plugins/colorscheme.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",      -- Nombre para referenciarlo
  lazy = false,
  priority = 1000,          -- Asegura que se cargue temprano
  config = function()
    local flavour = "frappe" -- << CAMBIA AQUÍ TU FLAVOUR PREFERIDO: "latte", "frappe", "macchiato", "mocha"

    local status_ok, catppuccin = pcall(require, "catppuccin")
    if not status_ok then
      -- Puedes dejar esta notificación de error si quieres, por si el plugin falla en el futuro
      vim.notify("Catppuccin plugin (main module) not found. Please check installation.", vim.log.levels.ERROR)
      return
    end

    catppuccin.setup({
      flavour = flavour,
      transparent_background = false,
      term_colors = true,
      -- SIN SECCIÓN DE INTEGRATIONS POR AHORA
      -- styles = {
      --   comments = { "italic" },
      --   conditionals = { "italic" },
      -- },
    })

    vim.cmd.colorscheme("catppuccin-" .. flavour)

    -- Verificación silenciosa opcional, o simplemente confiar en que funciona
    -- if vim.g.colors_name == ("catppuccin-" .. flavour) then
    --   -- Todo bien
    -- else
    --   vim.notify("Failed to apply Catppuccin theme (Simple Setup). Current: " .. (vim.g.colors_name or "nil"), vim.log.levels.ERROR)
    -- end
  end,
}
