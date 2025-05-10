-- lua/config/keymaps.lua

-- === TUS MAPEOS GLOBALES EXISTENTES (NO SE TOCAN) ===
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', {desc = "Close current buffer" })
vim.keymap.set('', '<leader>rr', ':source %<cr>', { desc = "Source the current file" })
vim.keymap.set('v', '>', '>gv', { desc = "after tab in re-select the same"})
vim.keymap.set('v', '<', '<gv', { desc = "after tab out re-select the same"})
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Goes to the next result on the seach and put the cursor in the middle"})
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Goes to the prev result on the seach and put the cursor in the middle"})

-- >>> INICIO: MAPEO SIMPLIFICADO PARA LIVE SERVER <<<
vim.keymap.set('n', '<leader>op', function()
  local current_ft = vim.bo.filetype
  if current_ft ~= 'html' and current_ft ~= 'htmldjango' and current_ft ~= 'markdown' then
    vim.notify("Comando <leader>op principalmente para archivos HTML/Markdown.", vim.log.levels.WARN, { title = "Live Server" })
    return 
  end

  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    vim.notify("No hay un archivo abierto para servir.", vim.log.levels.WARN, { title = "Live Server" })
    return
  end
  local file_dir = vim.fn.expand('%:p:h') 
  local file_name_to_serve = vim.fn.expand('%:t')

  local tt_status, toggleterm = pcall(require, "toggleterm.terminal")
  if not tt_status or not toggleterm or not toggleterm.Terminal then
    vim.api.nvim_err_writeln("Error: toggleterm.nvim no está disponible para el mapeo de live-server.")
    vim.notify("toggleterm.nvim no está disponible.", vim.log.levels.ERROR, { title = "Live Server" })
    return
  end

  local Terminal = toggleterm.Terminal
  local FIXED_LIVE_SERVER_ID = 2000 -- Un ID numérico fijo para nuestro live-server

  -- Intentar encontrar un terminal existente con el ID fijo
  local existing_term
  local all_terms_status, all_terms = pcall(toggleterm.get_all)
  if all_terms_status and type(all_terms) == "table" then
    for _, t in ipairs(all_terms) do
      if t.id == FIXED_LIVE_SERVER_ID then -- Comparar directamente el ID numérico
        existing_term = t
        break
      end
    end
  end

  if existing_term then
    if existing_term:is_running() then
      vim.notify("Live-server ya está corriendo (ID: " .. FIXED_LIVE_SERVER_ID .. "). Mostrando terminal.", vim.log.levels.INFO, { title = "Live Server" })
      existing_term:open() -- Asegura que esté visible
      -- Podrías querer que esto también intente refrescar el navegador,
      -- pero live-server debería hacerlo al guardar archivos.
    else
      -- El terminal existe pero el proceso no está corriendo (ej. Ctrl+C en él).
      -- Podríamos reabrirlo con el mismo comando.
      vim.notify("Reiniciando Live-server en terminal existente (ID: " .. FIXED_LIVE_SERVER_ID .. ").", vim.log.levels.INFO, { title = "Live Server" })
      existing_term.cmd = "live-server --open=./" .. vim.fn.shellescape(file_name_to_serve) -- Actualizar comando por si el archivo cambió
      existing_term.dir = file_dir -- Actualizar directorio por si cambió
      existing_term:open() -- Reabre y ejecuta el nuevo cmd
      -- Ocultar después de un retraso
      vim.defer_fn(function()
        if existing_term and existing_term:is_open() then existing_term:close() end
      end, 3000)
    end
    return 
  end

  -- Si no existe, crear uno nuevo
  vim.notify("Iniciando nuevo Live-server (ID: " .. FIXED_LIVE_SERVER_ID .. ") para: " .. file_name_to_serve, vim.log.levels.INFO, { title = "Live Server" })
  local cmd_to_run = "live-server --open=./" .. vim.fn.shellescape(file_name_to_serve)

  local term_instance = Terminal:new({
    cmd = cmd_to_run,
    dir = file_dir,
    direction = "float", 
    hidden = false, 
    close_on_exit = true,
    id = FIXED_LIVE_SERVER_ID, -- Usar el ID numérico fijo
    display_name = "Live Server (" .. FIXED_LIVE_SERVER_ID .. ")",
    on_open = function(opened_terminal)
      vim.api.nvim_buf_set_keymap(opened_terminal.bufnr, "t", "<esc>", "<c-\\><c-n>", {noremap = true, silent = true})
      vim.api.nvim_buf_set_keymap(opened_terminal.bufnr, "t", "<C-q>", "<c-\\><c-n><cmd>close<CR>", {noremap = true, silent = true})
      vim.notify("Live-server iniciado (ID: " .. FIXED_LIVE_SERVER_ID .. "). Terminal se ocultará.", vim.log.levels.INFO, { title = "Live Server" })
      
      vim.defer_fn(function()
        if opened_terminal and opened_terminal:is_open() then
          opened_terminal:close() 
        end
      end, 3000)
    end,
    on_close = function() 
      vim.notify("Proceso de Live-server (ID: ".. FIXED_LIVE_SERVER_ID ..") detenido.", vim.log.levels.INFO, { title = "Live Server" })
    end
  })
  term_instance:open()

end, { desc = "Open/Toggle Live Server (ToggleTerm)" })
