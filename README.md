# ✨ Mi Configuración de NeoVim ~ 2025 ✨

Esta es la configuración base de mi terminal en NeoVim, ¡en constante evolución hacia la perfección!

## 🌳 Distribución de Archivos

> Así se organizan las piezas de este rompecabezas:

*   📂 **ftplugin**
    *   📄 `c.lua`
    *   📄 `cpp.lua`
    *   📄 `lua.lua`
*   📂 **lua**
    *   📂 **config**
        *   📂 **plugins**
            *   📄 `cmp.lua`
            *   📄 `luasnip.lua`
        *   📄 `init.lua`
        *   📄 `keymaps.lua`
        *   📄 `lazy.lua`
        *   📄 `settings.lua`
    *   📂 **plugins**
        *   📄 `cmp.lua`
        *   📄 `colorscheme.lua`
        *   📄 `dadbod.lua`
        *   📄 `fugitive.lua`
        *   📄 `gitsigns.lua`
        *   📄 `lsp.lua`
        *   📄 `lualine.lua`
        *   📄 `luasnip.lua`
        *   📄 `mason.lua`
        *   📄 `none-ls.lua`
        *   📄 `notify.lua`
        *   📄 `telescope.lua`
        *   📄 `tree-sitter.lua`
*   📄 `init.lua` (Raíz)
*   📄 `lazy-lock.json`

> Esta es la distribución de archivos con la que se ha realizado la configuración para el entorno de Neovim.

---

## 🛠️ Detalles de la Configuración

### 📄 `init.lua` (Raíz)

Este es el punto de entrada principal de la configuración.

```lua
require("config")
vim.api.nvim_create_user_command("Binario", function()
  local picker = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  picker.new({}, {
    prompt_title = "Binario",
    finder = finders.new_table({
      results = { "alpha", "beta", "delta", "omega" }
    }),
    sorter = conf.generic_sorter(),
    previewer = false,
    attach_mappings = function (_, map)
      map("i", "<cr>", function (promt_bufnr)
        actions.close(promt_bufnr)
        local entry = action_state.get_selected_entry()
        vim.notify(entry[1])
      end)

      return true
    end,
  }):find()
end, {})
```

---

### 📂 `ftplugin/`

Configuraciones específicas por tipo de archivo (`filetype plugin`).

#### 📄 `ftplugin/c.lua`

Ajustes para archivos C.

```lua
vim.bo.tabstop = 2      -- Número de espacios que cuenta un <Tab>
vim.bo.softtabstop = 2  -- Número de espacios para <Tab> al editar (si es >0, usa mezcla de tabs/espacios)
vim.bo.shiftwidth = 2   -- Número de espacios para indentación automática (>>, <<)
vim.bo.expandtab = true -- Usar espacios en lugar de caracteres <Tab> literales
```

#### 📄 `ftplugin/cpp.lua`

Ajustes para archivos C++.

```lua
vim.bo.tabstop = 2      -- Número de espacios que cuenta un <Tab>
vim.bo.softtabstop = 2  -- Número de espacios para <Tab> al editar (si es >0, usa mezcla de tabs/espacios)
vim.bo.shiftwidth = 2   -- Número de espacios para indentación automática (>>, <<)
vim.bo.expandtab = true -- Usar espacios en lugar de caracteres <Tab> literales
```

#### 📄 `ftplugin/lua.lua`

Ajustes para archivos Lua.

```lua
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
```

---

### 📂 `lua/`

El corazón de la configuración, escrito en Lua.

#### 📂 `lua/config/`

Módulos de configuración principales.

##### 📄 `lua/config/init.lua`

Inicializa las configuraciones básicas y el gestor de plugins.

```lua
require "config.settings"
require "config.lazy"
```

##### 📄 `lua/config/keymaps.lua`

Definición de atajos de teclado globales y específicos.

```lua
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', {desc = "Close current buffer" })

vim.keymap.set('', '<leader>rr', ':source %<cr>', { desc = "Source the current file" })

vim.keymap.set('v', '>', '>gv', { desc = "after tab in re-select the same"})
vim.keymap.set('v', '<', '<gv', { desc = "after tab out re-select the same"})

vim.keymap.set('n', 'n', 'nzzzv', { desc = "Goes to the next result on the seach and put the cursor in the middle"})
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Goes to the prev result on the seach and put the cursor in the middle"})
```

##### 📄 `lua/config/lazy.lua`

Configuración del gestor de plugins `lazy.nvim`.

```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
```

##### 📄 `lua/config/settings.lua`

Configuraciones generales de Neovim (opciones).

```lua
vim.o.number = true
vim.o.relativenumber = true
vim.g.mapleader = " "
vim.o.termguicolors = true
```

---

#### 📂 `lua/config/plugins/`

Configuraciones detalladas para plugins específicos que se cargan a través de `lazy.nvim` pero tienen su lógica en `config.plugins.*`.

##### 📄 `lua/config/plugins/cmp.lua`

Configuración para `nvim-cmp` (autocompletado).

```lua
---@diagnostic disable: missing-fields
local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_autopairs = require "nvim-autopairs.completion.cmp"

local M = {}

function M.setup()
  cmp.setup({
    window = {
      completion = {
        border = "rounded",
      },
      documentation = {
        border = "rounded",
      },
    },
    formatting = {
      format = function(entry, vim_item)
        local KIND_ICONS = {
          Tailwind = '󰹞󰹞󰹞󰹞󰹞󰹞󰹞󰹞',
          Color = ' ',
          Snippet = " ",
        }
        if vim_item.kind == 'Color' and entry.completion_item.documentation then
          local _, _, r, g, b =
          ---@diagnostic disable-next-line: param-type-mismatch
              string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
		  local color

          if r and g and b then
			color = string.format('%02x', r) .. string.format('%02x', g) .. string.format('%02x', b)
		  else
			color = entry.completion_item.documentation:gsub('#', '')
          end
          local group = 'Tw_' .. color

          if vim.api.nvim_call_function('hlID', { group }) < 1 then
            vim.api.nvim_command('highlight' .. ' ' .. group .. ' ' .. 'guifg=#' .. color)
          end

          vim_item.kind = KIND_ICONS.Tailwind
          vim_item.kind_hl_group = group

          return vim_item
        end

        vim_item.kind = KIND_ICONS[vim_item.kind] or vim_item.kind

        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-y>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      ["<c-space>"] = cmp.mapping.complete(),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "luasnip" },
      { name = "buffer" },
    },
  })

  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })

  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

return M
```

##### 📄 `lua/config/plugins/luasnip.lua`

Configuración para `LuaSnip` (gestor de snippets).

```lua
local ls = require "luasnip"
local types = require "luasnip.util.types"

local M = {}

function M.setup()
  ls.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<- Choice", "Error" } },
        },
      },
    },
  }

  vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)
end

return M
```

---

#### 📂 `lua/plugins/`

Definiciones de plugins para `lazy.nvim`. Cada archivo representa un plugin o un conjunto de plugins relacionados.

##### 📄 `lua/plugins/cmp.lua`

Plugin: `nvim-cmp` y sus dependencias.

```lua
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-git",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "windwp/nvim-autopairs",
  },
  event = "VeryLazy",
  main = "config.plugins.cmp", -- Carga la configuración desde lua/config/plugins/cmp.lua
  config = true,
}
```

##### 📄 `lua/plugins/colorscheme.lua`

Plugin: `vim-enfocado` (tema de colores).

```lua
return {
  "wuelnerdotexe/vim-enfocado",
  lazy = false,
  priority = 1000,
  config = function()
  	vim.cmd([[colorscheme enfocado]])
  end,
}
```

##### 📄 `lua/plugins/dadbod.lua`

Plugin: `vim-dadbod` (manejo de bases de datos).

```lua
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
            vim.notify("Variable de entorno DB_POSTGRES_LOCAL_URL no definida.", vim.log.levels.WARN)
          end

          if mysql_url then
            connections.mysql_local_root = { url = mysql_url }
          else
            vim.notify("Variable de entorno DB_MYSQL_LOCAL_URL no definida.", vim.log.levels.WARN)
          end

          vim.g.db_ui_connections = connections

          vim.keymap.set("n", "<leader>dbu", "<cmd>DBUIToggle<cr>", { desc = "Toggle DB UI" })
        end,
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    event = "VeryLazy",
  },
}
```

##### 📄 `lua/plugins/fugitive.lua`

Plugin: `vim-fugitive` (integración con Git).

```lua
return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git" },
  keys = {
    { "<leader>ga", ":Git fetch --all -p<cr>", desc = "Git fetch" },
    { "<leader>gl", ":Git pull<cr>",           desc = "Git pull" },
  },
}
```

##### 📄 `lua/plugins/gitsigns.lua`

Plugin: `gitsigns.nvim` (indicadores de cambios de Git en el gutter).

```lua
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signcolumn = false,
    numhl = true,
    max_file_length = 10000,
  }
}
```

##### 📄 `lua/plugins/lsp.lua`

Plugin: `nvim-lspconfig` (configuración para Language Server Protocol).

```lua
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
    require("lspconfig").clangd.setup({
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })
  end
}
```

##### 📄 `lua/plugins/lualine.lua`

Plugin: `lualine.nvim` (barra de estado mejorada).

```lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {"nvim-tree/nvim-web-devicons"},
  opts = {
    options = {
      globalstatus = true,
    },
    sections = {
      lualine_c = {{"filename", file_status=true, path = 1}},
    },
    inactive_winbar = {
      lualine_c = { "filename" },
    }
  },
}
```

##### 📄 `lua/plugins/luasnip.lua`

Plugin: `LuaSnip` (motor de snippets).

```lua
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  main = "config.plugins.luasnip", -- Carga la configuración desde lua/config/plugins/luasnip.lua
  config = true,
}
```

##### 📄 `lua/plugins/mason.lua`

Plugin: `mason.nvim` (gestor de LSPs, linters, formatters).

```lua
return {
  "williamboman/mason.nvim",
  config = true, -- O usa `opts = {}` si no hay configuración específica aquí
}
```

##### 📄 `lua/plugins/none-ls.lua`

Plugin: `none-ls.nvim` (antes null-ls, para linters y formatters como fuentes LSP).

```lua
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local B = null_ls.builtins

    null_ls.setup({
      sources = {
        B.formatting.clang_format.with({
          -- extra_args = {"--style=file"},
        }),
      },
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
```

##### 📄 `lua/plugins/notify.lua`

Plugin: `nvim-notify` (notificaciones mejoradas).

```lua
---@diagnostic disable: missing-fields
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require "notify"
    notify.setup { background_colour = "#000000" }
    vim.notify = notify.notify
  end,
}
```

##### 📄 `lua/plugins/telescope.lua`

Plugin: `telescope.nvim` (buscador fuzzy).

```lua
return {
  "nvim-telescope/telescope.nvim",
  event = 'VeryLazy',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    }
  },
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    }
  },
  config = function(_, opts) -- El primer argumento es el plugin spec, el segundo son las opts
    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
  end,
  keys = {
    { "<leader>pp", function() require('telescope.builtin').git_files({ show_untracked = true }) end, desc = "Telescope Git Files" },
    { "<leader>pe", function() require("telescope.builtin").buffers() end, desc = "Telescope buffers" },
    { "<leader>gs", function() require("telescope.builtin").git_status() end, desc = "Telescope Git status" },
    { "<leader>gc", function() require("telescope.builtin").git_bcommits() end, desc = "Telescope Git bcommits" },
    { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Telescope Git branches" },
    { "<leader>rp", function()
        require("telescope.builtin").find_files({
          prompt_title = "Plugins",
          cwd = "~/.config/nvim/lua/plugins",
          attach_mappings = function(_, map)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            map("i", "<c-y>", function(prompt_bufnr)
              local new_plugin = action_state.get_current_line()
              actions.close(prompt_bufnr)
              vim.cmd(string.format("edit ~/.config/nvim/lua/plugins/%s.lua", new_plugin))
            end)
            return true
          end
        })
      end, desc = "Telescope Plugins (custom)"
    },
    { "<leader>pf", function() require('telescope.builtin').find_files() end, desc = "Telescope Find Files" },
    { "<leader>ph", function() require("telescope.builtin").help_tags() end, desc = "Telescope Help" },
    { "<leader>bb", function() require("telescope").extensions.file_browser.file_browser({ path = "%:h:p", select_buffer = true }) end, desc = "Telescope file browser" }
  },
}
```

##### 📄 `lua/plugins/tree-sitter.lua`

Plugin: `nvim-treesitter` (mejor resaltado de sintaxis y más).

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/playground",
  },
  build        = ":TSUpdate",
  event        = "VeryLazy",
  main         = "nvim-treesitter.configs",
  opts         = {
    ensure_installed = {
      "lua",
      "luadoc",
      "query",
      "c",
      "cpp",
      "markdown",
      "markdown_inline",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
        }
      }
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    }
  },
}
```

---

> 🚀 De momento estos son todos los archivos y plugins que se usan para esta configuración base de Neovim. ¡A seguir codeando!
