-- lua/plugins/none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- Cargar cuando se lee o crea un archivo
  dependencies = {
    "nvim-lua/plenary.nvim", -- Puede ser necesario para algunas funcionalidades internas
    "nvimtools/none-ls-extras.nvim", -- Opcional, pero añade más fuentes útiles si las necesitas en el futuro
  },
  config = function()
    local null_ls = require("null-ls") -- Sí, el require sigue siendo "null-ls" para none-ls
    local B = null_ls.builtins

    null_ls.setup({
      sources = {
        -- Formateadores
        B.formatting.clang_format.with({
          -- `extra_args` puede ser útil. Por ejemplo, para usar el estilo del proyecto:
          -- extra_args = {"--style=file"},
          -- Si no tienes un .clang-format, usará un estilo por defecto (LLVM usualmente)
          -- o puedes especificar uno: extra_args = {"--style=Google"},
          -- Por ahora, lo dejaremos sin extra_args para que use el default o .clang-format si existe.
        }),
        -- Aquí podrías añadir más formateadores para otros lenguajes en el futuro
        -- Ejemplo: B.formatting.stylua, -- Para formatear Lua
      },

      -- Opcional: Configurar formateo al guardar
     -- Si quieres esta funcionalidad, descomenta el siguiente bloque 'on_attach'
      -- Si ya tienes un autocmd para formatear al guardar en tu 'on_attach' de lspconfig,
      -- podrías tener conflictos o doble formateo. Elige uno.
      -- Yo recomiendo que el formateo al guardar lo maneje none-ls si lo usas para formatear.

      -- on_attach = function(client, bufnr)
      --   if client.supports_method("textDocument/formatting") then
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       buffer = bufnr,
      --       callback = function()
      --         vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 2000 })
      --       end,
      --       desc = "Format on save (none-ls)",
      --     })
      --   end
      -- end,
    })
  end,
}
