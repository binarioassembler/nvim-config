-- lua/plugins/none-ls.lua (MÍNIMA - Solo clang-format y SIN PHP)
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- "nvimtools/none-ls-extras.nvim", -- Puedes descomentarlo si necesitas eslint/stylelint
  },
  config = function()
    -- vim.notify("None-LS: Iniciando config (MÍNIMA, SIN PHP)", vim.log.levels.INFO, {title="None-LS"})

    local null_ls_ok, null_ls = pcall(require, "null-ls")
    if not null_ls_ok then
      vim.schedule(function()
        vim.notify("Error: none-ls (null-ls) no pudo ser requerido: " .. tostring(null_ls), vim.log.levels.ERROR, { title = "None-LS Error" })
      end)
      return
    end

    local B_ok, B = pcall(function() return null_ls.builtins end)
    if not B_ok then 
      -- vim.notify("None-LS: Error al cargar null_ls.builtins. B se establecerá a tabla vacía.", vim.log.levels.WARN, { title = "None-LS" })
      B = {} 
    end

    local sources = {}
    local mason_bin_dir = vim.fn.stdpath("data") .. "/mason/bin/"

    -- 1. CLANG FORMAT
    if B and B.formatting and B.formatting.clang_format then
      local clang_format_path = mason_bin_dir .. "clang-format"
      if vim.fn.executable(clang_format_path) == 1 then
        table.insert(sources, B.formatting.clang_format.with({
          command = clang_format_path,
        }))
        -- vim.notify("None-LS: clang_format añadido.", vim.log.levels.INFO, { title = "None-LS" })
      else
        vim.notify("None-LS: clang-format NO es ejecutable en Mason: " .. clang_format_path, vim.log.levels.WARN, { title = "None-LS" })
      end
    else
      vim.notify("None-LS: Builtin para clang_format NO disponible.", vim.log.levels.WARN, { title = "None-LS" })
    end

    -- AQUÍ PODRÍAS REINTRODUCIR ESLINT Y STYLELINT SI QUIERES Y SI FUNCIONABAN ANTES
    -- PERO NO AÑADAS NADA DE PHPCS O PHP-CS-FIXER

    if #sources > 0 then
      local setup_ok, setup_err = pcall(null_ls.setup, {
        debug = false,
        sources = sources,
      })
      if not setup_ok then
        vim.notify("None-LS: ERROR en null_ls.setup: " .. tostring(setup_err), vim.log.levels.ERROR, {title="None-LS"})
      else
        -- vim.notify("None-LS: null_ls.setup completado con " .. #sources .. " fuente(s).", vim.log.levels.INFO, {title="None-LS"})
      end
    else
      -- vim.notify("None-LS: Ninguna fuente para configurar.", vim.log.levels.INFO, { title = "None-LS" })
    end
  end,
}
