# Mi configuración de NeoVim 2025
Esta es la configuración base de mi terminal en neovim, está en proceso de desarrollo.

## Distribución de archivos
* :open_file_folder: **ftplugin**
	* :page_facing_up: c.lua
	* :page_facing_up: cpp.lua
	* :page_facing_up: lua.lua
* :open_file_folder: **lua**
	* :open_file_folder: **config**
		* :open_file_folder: **plugins**
			* :page_facing_up: cmp-lua
			* :page_facing_up: luasnip.lua
		* :page_facing_up: init.lua
		* :page_facing_up: keymaps.lua
		* :page_facing_up: lazy.lua
		* :page_facing_up: settings.lua
	* :open_file_folder: **plugins**
		* :page_facing_up: cmp.lua
		* :page_facing_up: colorscheme.lua
		* :page_facing_up: gitsigns.lua
		* :page_facing_up: lsp.lua
		* :page_facing_up: lualine.lua
		* :page_facing_up: luasnip.lua
		* :page_facing_up: mason.lua
		* :page_facing_up: none-ls.lua
		* :page_facing_up: notify.lua
		* :page_facing_up: telescope.lua
		* :page_facing_up: tree-sitter.lua
* :page_facing_up: init.lua
* :page_facing_up: lazy-lock.json
> Esta es la distribución de archivos con la que se ha realizado la configuración para el entorno de neovim.

## Detalles de la configuración
### Archivo raíz
:page_facing_up: init.lua
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
[¹]: Esta es la explicación de la nota al pie.
***
### :open_file_folder: Directorio ftplugin
:page_facing_up: c.lua
```lua
vim.bo.tabstop = 2      -- Número de espacios que cuenta un <Tab>
vim.bo.softtabstop = 2  -- Número de espacios para <Tab> al editar (si es >0, usa mezcla de tabs/espacios)
vim.bo.shiftwidth = 2   -- Número de espacios para indentación automática (>>, <<)
vim.bo.expandtab = true -- Usar espacios en lugar de caracteres <Tab> literales
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: cpp.lua
```lua
vim.bo.tabstop = 2      -- Número de espacios que cuenta un <Tab>
vim.bo.softtabstop = 2  -- Número de espacios para <Tab> al editar (si es >0, usa mezcla de tabs/espacios)
vim.bo.shiftwidth = 2   -- Número de espacios para indentación automática (>>, <<)
vim.bo.expandtab = true -- Usar espacios en lugar de caracteres <Tab> literales
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: lua.lua
```lua
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
```
[¹]: Esta es la explicación de la nota al pie.
***
### :open_file_folder: Directorio lua
#### :open_file_folder: lua/config
:page_facing_up: init.lua
```lua
require "config.settings"
require "config.lazy"
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: keymaps.lua
```lua
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', {desc = "Close current buffer" })

vim.keymap.set('', '<leader>rr', ':source %<cr>', { desc = "Source the current file" })

vim.keymap.set('v', '>', '>gv', { desc = "after tab in re-select the same"})
vim.keymap.set('v', '<', '<gv', { desc = "after tab out re-select the same"})

vim.keymap.set('n', 'n', 'nzzzv', { desc = "Goes to the next result on the seach and put the cursor in the middle"})
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Goes to the prev result on the seach and put the cursor in the middle"})
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: lazy.lua
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
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: settings.lua
```lua
vim.o.number = true
vim.o.relativenumber = true
vim.g.mapleader = " "
vim.o.termguicolors = true
```
[¹]: Esta es la explicación de la nota al pie.

##### :open_file_folder: lua/config/plugins
:page_facing_up: cmp.lua
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
          -- Class = 7,
          -- Constant = '󰚞',
          -- Constructor = 4,
          -- Enum = 13,
          -- EnumMember = 20,
          -- Event = 23,
          -- Field = 5,
          -- File = 17,
          -- Folder = 19,
          -- Function = 3,
          -- Interface = 8,
          -- Keyword = 14,
          -- Method = 2,
          -- Module = 9,
          -- Operator = 24,
          -- Property = 10,
          -- Reference = 18,
          Snippet = " ",
          -- Struct = 22,
          -- Text = "",
          -- TypeParameter = 25,
          -- Unit = 11,
          -- Value = 12,
          -- Variable = 6
        }
        if vim_item.kind == 'Color' and entry.completion_item.documentation then
          local _, _, r, g, b =
          ---@diagnostic disable-next-line: param-type-mismatch
              string.find(entry.completion_item.documentation, '^rgb%((%d+), (%d+), (%d+)')
		  local color

		  -- The next conditional is for the new tailwindcss version.
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

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
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
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: luasnip.lua
```lua
local ls = require "luasnip"
local types = require "luasnip.util.types"

local M = {}

function M.setup()
  ls.config.set_config {
    -- This tells LuaSnip to remember to keep around the last snippet.
    -- You can jump back into even if you move outside of the selection
    history = true,

    -- This one is cool cause if you have dynamic snippets, it updatesas you type!
    updateevents = "TextChanged,TextChangedI",

    -- Autosnippets:
    enable_autosnippets = true,

    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<- Choice", "Error" } },
        },
      },
    },
  }

  -- <c-k> is my expansion key
  -- this will expand the current item or jump to the next item within the snippet.
  vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })

  -- <c-j> is my jump backwards key.
  -- this always moves to the previous item within the snippet
  vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  -- <c-l> is selecting within a list of options.
  -- This is useful for choice nodes (introduced in the forthcoming episode 2)
  vim.keymap.set("i", "<c-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)
end

return M
```
[¹]: Esta es la explicación de la nota al pie.

***
#### :open_file_folder: lua/plugins
:page_facing_up: cmp.lua
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
  main = "config.plugins.cmp",
  config = true,
}
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: colorscheme.lua
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
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: fugitive.lua
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
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: gitsigns.lua
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
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: lsp.lua
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
    -- >>> Lenguaje C/C++ añadido
    require("lspconfig").clangd.setup({
      on_attach = on_attach, -- Reutilizamos la misma función on_attach
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      -- cmd = {"clangd"}, -- Mason usualmente maneja esto. No es necesario si Mason está funcionando.
      -- filetypes = {"c", "cpp", "objc", "objcpp", "cuda"}, -- Mason también suele manejar esto.
    })
  end
}
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: lualine.lua
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
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: luasnip.lua
```lua
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  main = "config.plugins.luasnip",
  config = true,
}
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: mason.lua
```lua
return {
  "williamboman/mason.nvim",
  config = true,
}
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: none-ls.lua
```lua
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
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: notify.lua
```lua
---@diagnostic disable: missing-fields
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require "notify"
    -- this for transparency
    notify.setup { background_colour = "#000000" }
    -- this overwrites the vim notify function
    vim.notify = notify.notify
  end,
}
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: telescope.lua
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
    } },
  opts = {
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    }
  },
  config = function(opts)
    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
  end,
  keys = {
    {
      "<leader>pp",
      function()
        require('telescope.builtin').git_files({ show_untracked = true })
      end,
      desc = "Telescope Git Files",
    },
    {
      "<leader>pe",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Telescope buffers",
    },
    {
      "<leader>gs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Telescope Git status",
    },
    {
      "<leader>gc",
      function()
        require("telescope.builtin").git_bcommits()
      end,
      desc = "Telescope Git status",
    },
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches()
      end,
      desc = "Telescope Git branches",
    },
    {
      "<leader>rp",
      function()
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
      end
    },
    {
      "<leader>pf",
      function()
        require('telescope.builtin').find_files()
      end,
      desc = "Telescope Find Files",
    },
    {
      "<leader>ph",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Telescope Help"
    },
    {
      "<leader>bb",
      function()
        require("telescope").extensions.file_browser.file_browser({ path = "%:h:p", select_buffer = true })
      end,
      desc = "Telescope file browser"
    }
  },
}
```
[¹]: Esta es la explicación de la nota al pie.

:page_facing_up: tree-sitter.lua
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
      updatetime = 25,       -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
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
[¹]: Esta es la explicación de la nota al pie.

> De momento estos son todos los archivos y plugins que se usa para esta configuración base de neovim.
