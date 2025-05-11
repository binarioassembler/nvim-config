-- lua/plugins/tree-sitter.lua
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
      "sql",
      "html",
      "css",
      "javascript",
      -- >>> AÑADIDOS/CONFIRMADOS PARA PHP <<<
      "php",
      "phpdoc", -- Para comentarios PHPDoc
      "json",   -- Útil para composer.json, etc.
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true, -- Treesitter puede ayudar con la indentación
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
          -- Puedes añadir textobjects específicos de PHP aquí más tarde si quieres
          -- ["aP"] = { query = "@class.outer", desc = "Select outer PHP class" },
          -- ["iP"] = { query = "@class.inner", desc = "Select inner PHP class" },
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
