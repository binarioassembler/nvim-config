-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    -- === MAPEOS GLOBALES DE LSP ===
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- === FUNCIÓN ON_ATTACH ===
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

    -- === REQUIRES Y VARIABLES LOCALES PARA LSP ===
    local lspconfig = require("lspconfig") -- Definir UNA VEZ aquí
    local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities() -- Definir UNA VEZ aquí

    -- === CONFIGURACIONES LSP EXISTENTES ===
    require("neodev").setup()
    lspconfig.lua_ls.setup({ -- Usar la variable local 'lspconfig'
      on_attach = on_attach,
      capabilities = cmp_capabilities, -- Usar la variable local 'cmp_capabilities'
      settings = {
        Lua = {
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        }
      }
    })

    lspconfig.clangd.setup({ -- Usar la variable local 'lspconfig'
      on_attach = on_attach,
      capabilities = cmp_capabilities, -- Usar la variable local 'cmp_capabilities'
      filetypes = {"c", "cpp", "objc", "objcpp", "cuda"},
    })

    lspconfig.sqlls.setup({ -- Usar la variable local 'lspconfig'
      on_attach = on_attach,
      capabilities = cmp_capabilities, -- Usar la variable local 'cmp_capabilities'
      filetypes = { "sql", "mysql", "plsql" },
    })

    -- >>> NUEVA CONFIGURACIÓN PARA HTML, CSS, JS Y EMMET <<<

    lspconfig.html.setup({ -- Usar la variable local 'lspconfig'
      on_attach = on_attach,
      capabilities = cmp_capabilities, -- Usar la variable local 'cmp_capabilities'
    })

    lspconfig.cssls.setup({ -- Usar la variable local 'lspconfig'
      on_attach = on_attach,
      capabilities = cmp_capabilities, -- Usar la variable local 'cmp_capabilities'
    })

    lspconfig.ts_ls.setup({ -- Usar la variable local 'lspconfig'
      on_attach = on_attach,
      capabilities = cmp_capabilities, -- Usar la variable local 'cmp_capabilities'
    })

    lspconfig.emmet_ls.setup({ -- Usar la variable local 'lspconfig'
      on_attach = on_attach,
      capabilities = cmp_capabilities, -- Usar la variable local 'cmp_capabilities'
      filetypes = {
        "html", "css", "scss", "less", "sass", "javascript", "javascriptreact",
        "typescriptreact", "haml", "xml", "xsl", "pug", "slim", "svelte", "vue",
      },
      cmd = { 
        "node", 
        "/home/binario/.local/share/nvim/mason/packages/emmet-language-server/node_modules/.bin/emmet-language-server", 
        "--stdio" 
      }
    })
    -- >>> FIN DE LA NUEVA CONFIGURACIÓN <<<

  end
}
