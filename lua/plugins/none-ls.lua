-- lua/plugins/none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  -- Vuelve a tu configuración de carga preferida, ej:
  event = { "BufReadPre", "BufNewFile" }, 
  -- lazy = false, -- Comenta o elimina esto si lo pusiste para depurar
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    -- vim.notify("none-ls: Iniciando función config...", vim.log.levels.INFO) -- DEBUG

    local null_ls_ok, null_ls = pcall(require, "null-ls")
    if not null_ls_ok then
      vim.notify("Error: none-ls (null-ls) no pudo ser requerido: " .. tostring(null_ls), vim.log.levels.ERROR)
      return
    end
    -- vim.notify("none-ls: Módulo 'null-ls' requerido.", vim.log.levels.INFO) -- DEBUG

    local builtins_ok, B = pcall(function() return null_ls.builtins end)
    if not builtins_ok then
      vim.notify("Error: null_ls.builtins no está disponible: " .. tostring(B), vim.log.levels.ERROR)
      return
    end
    -- vim.notify("none-ls: Módulo 'null-ls.builtins' accesible.", vim.log.levels.INFO) -- DEBUG

    local sources = {}
    local eslint_source_ok, eslint_source

    -- 1. CLANG FORMAT
    if B.formatting.clang_format then
        table.insert(sources, B.formatting.clang_format)
        -- vim.notify("none-ls: clang_format añadido desde builtins.", vim.log.levels.INFO) -- DEBUG
    else
        vim.notify("none-ls: B.formatting.clang_format NO disponible.", vim.log.levels.WARN)
    end

    -- 2. ESLINT (eslint_d o eslint)
    eslint_source_ok, eslint_source = pcall(require, "none-ls.diagnostics.eslint_d")
    if not eslint_source_ok then
      eslint_source_ok, eslint_source = pcall(require, "none-ls.diagnostics.eslint")
    end

    if eslint_source_ok and eslint_source then
      -- vim.notify("none-ls: Fuente eslint/eslint_d REQUERIDA exitosamente.", vim.log.levels.INFO) -- DEBUG
      local eslint_exec = vim.fn.executable("eslint_d") == 1 and "eslint_d" or (vim.fn.executable("eslint") == 1 and "eslint" or nil)
      if eslint_exec then
          local eslint_path = vim.fn.trim(vim.fn.system("which " .. eslint_exec))
          table.insert(sources, eslint_source.with({
              command = eslint_path,
              condition = function(utils)
                return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", "package.json" })
              end,
              diagnostics_format = '[eslint] #{m} (#{c})' -- Puedes mantener o quitar el '_d' aquí
          }))
          -- vim.notify("none-ls: " .. eslint_exec .. " configurado y añadido a sources.", vim.log.levels.INFO) -- DEBUG
      else
          vim.notify("none-ls: No se encontró ejecutable para eslint ni eslint_d. Intentando añadir fuente sin 'command'.", vim.log.levels.WARN)
          table.insert(sources, eslint_source)
      end
    else
      vim.notify("none-ls: No se pudo REQUERIR ninguna fuente eslint/eslint_d.", vim.log.levels.ERROR)
    end

    -- 3. STYLELINT
    if B.diagnostics.stylelint then
      -- vim.notify("none-ls: Builtin B.diagnostics.stylelint ENCONTRADO.", vim.log.levels.INFO) -- DEBUG
      local stylelint_path = vim.fn.trim(vim.fn.system("which stylelint"))
      if vim.v.shell_error == 0 and stylelint_path ~= "" then
        -- vim.notify("none-ls: Path para stylelint: " .. stylelint_path, vim.log.levels.INFO) -- DEBUG
        table.insert(sources, B.diagnostics.stylelint.with({
          command = stylelint_path,
          condition = function(utils)
            return utils.root_has_file({ ".stylelintrc.json", ".stylelintrc.js", "stylelint.config.js", "package.json"})
          end,
          diagnostics_format = '[stylelint] #{m}'
        }))
        -- vim.notify("none-ls: stylelint añadido a sources con path.", vim.log.levels.INFO) -- DEBUG
      else
        vim.notify("none-ls: stylelint NO encontrado en PATH, intentando sin path explícito.", vim.log.levels.WARN)
        table.insert(sources, B.diagnostics.stylelint)
        -- vim.notify("none-ls: stylelint añadido a sources (sin path explícito).", vim.log.levels.INFO) -- DEBUG
      end
    else
      vim.notify("none-ls: Builtin B.diagnostics.stylelint NO ENCONTRADO.", vim.log.levels.ERROR)
    end

    -- Configuración de none-ls
    if #sources > 0 then
      null_ls.setup({
        -- debug = true, -- Cambia a false cuando ya no necesites depurar
        debug = false, 
        sources = sources,
        -- on_attach = function(client, bufnr) -- Comenta si no quieres la notificación de adjunto
          -- vim.notify("none-ls: Cliente '" .. client.name .. "' adjunto al buffer " .. bufnr, vim.log.levels.INFO)
        -- end,
      })
      -- local source_names = {}
      -- for _, s_obj in ipairs(sources) do table.insert(source_names, s_obj.name or "fuente_sin_nombre") end
      -- vim.notify("none-ls.nvim configurado con fuentes: " .. table.concat(source_names, ", "), vim.log.levels.INFO) -- DEBUG
    else
      vim.notify("none-ls: Ninguna fuente válida para configurar.", vim.log.levels.ERROR)
    end
  end,
}
