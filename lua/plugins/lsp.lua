return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    local on_attach = function(_, bufnr)
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      local opts = { buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, { buffer= bufnr, desc = "Format code (LSP)"})
    end

    require("neodev").setup()
    require("lspconfig").lua_ls.setup({
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      settings = {
        Lua = {
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        }
      }
    })
    -- >>> Lenguaje C/C++ añadido
    require("lspconfig").clangd.setup({
      on_attach = on_attach, -- Reutilizamos la misma función on_attach
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      -- cmd = {"clangd"}, -- Mason usualmente maneja esto. No es necesario si Mason está funcionando.
      -- filetypes = {"c", "cpp", "objc", "objcpp", "cuda"}, -- Mason también suele manejar esto.
    })
    -- >>> Lenguaje SQL añadido
    require("lspconfig").sqlls.setup({
    on_attach = on_attach, -- Reutiliza la misma función on_attach
    capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Reutiliza las mismas capabilities que definiste arriba
  -- sqlls puede tener configuraciones específicas, pero empecemos con lo básico
  -- Por ejemplo, para especificar el dialecto si es necesario (opcional):
      --settings = {
        --sqlls = {
          --dialect = "mysql", -- o "postgresql"
          -- Puedes añadir configuraciones de conexión aquí si el LSP las soporta
          -- para que conozca tu esquema, pero vim-dadbod ya maneja la conexión.
        --}
      --}
  -- Para empezar, no necesitamos settings específicos.
})
end
}
