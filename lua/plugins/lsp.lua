-- lua/plugins/lsp.lua (Permitiendo que Intelephense formatee)
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "folke/neodev.nvim",
  },
  config = function()
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "LSP: Show line diagnostics" })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "LSP: Go to previous diagnostic" })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "LSP: Go to next diagnostic" })
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "LSP: Open diagnostics list" })

    local on_attach = function(client, bufnr)
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      local base_opts = { buffer = bufnr, noremap = true, silent = true }
      local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', base_opts, { desc = "LSP: " .. desc })) end
      map('n', 'gD', vim.lsp.buf.declaration, "Go to Declaration"); map('n', 'gd', vim.lsp.buf.definition, "Go to Definition"); map('n', 'K', vim.lsp.buf.hover, "Hover Documentation"); map('n', 'gi', vim.lsp.buf.implementation, "Go to Implementation"); map('n', '<C-k>', vim.lsp.buf.signature_help, "Signature Help"); map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, "Add Workspace Folder"); map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder"); map('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders"); map('n', '<space>D', vim.lsp.buf.type_definition, "Go to Type Definition"); map('n', '<space>rn', vim.lsp.buf.rename, "Rename Symbol"); map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, "Code Action"); map('n', 'gr', vim.lsp.buf.references, "Go to References"); map('n', '<space>f', function() vim.lsp.buf.format { async = true } end, "Format Code")

      -- El siguiente bloque ESTÁ COMENTADO para permitir que Intelephense formatee.
      -- if client.name == "intelephense" then
      --   -- vim.notify("LSP: Intelephense adjunto. Desactivando su formateador.", vim.log.levels.INFO, {title = "LSP Setup"})
      --   client.server_capabilities.documentFormattingProvider = false
      --   client.server_capabilities.documentRangeFormattingProvider = false
      -- end
    end

    local lspconfig = require("lspconfig"); local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    require("neodev").setup()
    lspconfig.lua_ls.setup({ on_attach = on_attach, capabilities = cmp_capabilities, settings = { Lua = { telemetry = { enable = false }, workspace = { checkThirdParty = false } } } }); lspconfig.clangd.setup({ on_attach = on_attach, capabilities = cmp_capabilities, filetypes = {"c", "cpp", "objc", "objcpp", "cuda"} }); lspconfig.sqlls.setup({ on_attach = on_attach, capabilities = cmp_capabilities, filetypes = { "sql", "mysql", "plsql" } }); lspconfig.html.setup({ on_attach = on_attach, capabilities = cmp_capabilities }); lspconfig.cssls.setup({ on_attach = on_attach, capabilities = cmp_capabilities }); lspconfig.ts_ls.setup({ on_attach = on_attach, capabilities = cmp_capabilities }); lspconfig.emmet_ls.setup({ on_attach = on_attach, capabilities = cmp_capabilities, filetypes = { "html", "css", "scss", "less", "sass", "javascript", "javascriptreact", "typescriptreact", "haml", "xml", "xsl", "pug", "slim", "svelte", "vue", "php", "blade", }, cmd = { "node", "/home/binario/.local/share/nvim/mason/packages/emmet-language-server/node_modules/.bin/emmet-language-server", "--stdio" } })
    lspconfig.intelephense.setup({ on_attach = on_attach, capabilities = cmp_capabilities, filetypes = { "php", "phtml", "blade" }, settings = { intelephense = { files = { maxSize = 5000000 }, environment = {}, stubs = { "apache", "bcmath", "bz2", "calendar", "Core", "ctype", "curl", "date", "dba", "dom", "enchant", "exif", "FFI", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext", "gmp", "hash", "iconv", "imap", "intl", "json", "ldap", "libxml", "mbstring", "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "phar", "posix", "pspell", "readline", "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL", "sqlite3", "standard", "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl", "zip", "zlib", }, } }, })
  end,
}
