-- lua/config/keymaps.lua

-- === TUS MAPEOS GLOBALES EXISTENTES ===
vim.keymap.set('n', '<leader>bd', ':bd!<cr>', {desc = "Close current buffer" })
vim.keymap.set('', '<leader>rr', ':source %<cr>', { desc = "Source the current file" })
vim.keymap.set('v', '>', '>gv', { desc = "after tab in re-select the same"})
vim.keymap.set('v', '<', '<gv', { desc = "after tab out re-select the same"})
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Goes to the next result on the seach and put the cursor in the middle"})
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Goes to the prev result on the seach and put the cursor in the middle"})

-- >>> MAPEO SIMPLIFICADO PARA LIVE SERVER (HTML/Markdown) <<<
vim.keymap.set('n', '<leader>op', function()
  local current_ft = vim.bo.filetype
  if current_ft ~= 'html' and current_ft ~= 'htmldjango' and current_ft ~= 'markdown' then
    vim.notify("Comando <leader>op principalmente para archivos HTML/Markdown.", vim.log.levels.WARN, { title = "Live Server" })
    return 
  end
  local file_path = vim.fn.expand('%:p'); if file_path == '' then vim.notify("No hay un archivo abierto para servir.", vim.log.levels.WARN, { title = "Live Server" }); return end
  local file_dir = vim.fn.expand('%:p:h'); local file_name_to_serve = vim.fn.expand('%:t')
  
  local tt_status, toggleterm_module = pcall(require, "toggleterm") 
  if not tt_status or not toggleterm_module then
    vim.api.nvim_err_writeln("Error: toggleterm.nvim (módulo principal) no está disponible."); return
  end
  local Terminal_constructor = require("toggleterm.terminal").Terminal 
  if not Terminal_constructor then
    vim.api.nvim_err_writeln("Error: toggleterm.terminal.Terminal no está disponible."); return
  end

  local FIXED_LIVE_SERVER_ID = 2000 
  local existing_term
  if toggleterm_module.get_term then 
      existing_term = toggleterm_module.get_term(function(term) return term.id == FIXED_LIVE_SERVER_ID end)
  end

  if existing_term then
    if existing_term:is_running() then vim.notify("Live-server ya corriendo (ID: " .. FIXED_LIVE_SERVER_ID .. "). Mostrando.", vim.log.levels.INFO, { title = "Live Server" }); existing_term:open()
    else vim.notify("Reiniciando Live-server (ID: " .. FIXED_LIVE_SERVER_ID .. ").", vim.log.levels.INFO, { title = "Live Server" }); existing_term:set_cmd("live-server --open=./" .. vim.fn.shellescape(file_name_to_serve)); existing_term:set_dir(file_dir); existing_term:open(); vim.defer_fn(function() if existing_term and existing_term:is_open() then existing_term:close() end end, 3000) end
    return 
  end
  vim.notify("Iniciando nuevo Live-server (ID: " .. FIXED_LIVE_SERVER_ID .. ") para: " .. file_name_to_serve, vim.log.levels.INFO, { title = "Live Server" }); local cmd_to_run = "live-server --open=./" .. vim.fn.shellescape(file_name_to_serve)
  local term_instance = Terminal_constructor:new({ cmd = cmd_to_run, dir = file_dir, direction = "float", hidden = false, close_on_exit = true, id = FIXED_LIVE_SERVER_ID, display_name = "Live Server (" .. FIXED_LIVE_SERVER_ID .. ")", on_open = function(opened_terminal) vim.api.nvim_buf_set_keymap(opened_terminal.bufnr, "t", "<esc>", "<c-\\><c-n>", {noremap = true, silent = true}); vim.api.nvim_buf_set_keymap(opened_terminal.bufnr, "t", "<C-q>", "<c-\\><c-n><cmd>close<CR>", {noremap = true, silent = true}); vim.notify("Live-server iniciado. Terminal se ocultará.", vim.log.levels.INFO, { title = "Live Server" }); vim.defer_fn(function() if opened_terminal and opened_terminal:is_open() then opened_terminal:close() end end, 3000) end, on_close = function() vim.notify("Proceso Live-server (ID: ".. FIXED_LIVE_SERVER_ID ..") detenido.", vim.log.levels.INFO, { title = "Live Server" }) end })
  term_instance:open()
end, { desc = "Open/Toggle Live Server (HTML/MD)" })


-- >>> INICIO: NUEVO MAPEO PARA SERVIDOR PHP CON TOGGLETERM <<<
local function start_php_server_and_open_browser()
  local current_file_name = vim.fn.expand('%:t') 
  local project_root = vim.fn.getcwd()     

  local file_to_serve_in_browser = current_file_name
  if file_to_serve_in_browser == "" then
    file_to_serve_in_browser = "index.php" 
    vim.notify("Ningún archivo abierto. Intentando abrir " .. file_to_serve_in_browser .. " en el navegador.", vim.log.levels.INFO, { title = "PHP Server" })
  elseif vim.bo.filetype ~= 'php' and not string.find(file_to_serve_in_browser, "%.php$") then
     vim.notify("El archivo actual no es PHP. Iniciando servidor PHP. Abriendo: " .. file_to_serve_in_browser, vim.log.levels.WARN, { title = "PHP Server" })
  end

  local port = "8000"
  local server_url = "http://localhost:" .. port .. "/" .. vim.fn.fnameescape(file_to_serve_in_browser)
  local php_server_cmd = "php -S localhost:" .. port

  local open_browser_cmd_string 
  if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
    open_browser_cmd_string = "open " .. vim.fn.shellescape(server_url)
  elseif vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
    open_browser_cmd_string = "xdg-open " .. vim.fn.shellescape(server_url)
  elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    open_browser_cmd_string = "explorer.exe " .. vim.fn.shellescape(server_url) -- En Windows, no se necesita shellescape para la URL con explorer.exe
                                             -- open_browser_cmd_string = "start " .. server_url -- Alternativa para Windows
  else
    vim.notify("No se pudo determinar el comando para abrir el navegador.", vim.log.levels.ERROR, { title = "PHP Server" })
  end

  local tt_status, toggleterm_module = pcall(require, "toggleterm")
  if not tt_status or not toggleterm_module then
    vim.api.nvim_err_writeln("Error: toggleterm.nvim (módulo principal) no está disponible para el servidor PHP.")
    return
  end
  local Terminal_constructor = require("toggleterm.terminal").Terminal
  if not Terminal_constructor then
    vim.api.nvim_err_writeln("Error: toggleterm.terminal.Terminal (constructor) no está disponible.")
    return
  end

  local PHP_SERVER_TERM_NAME = "PHP_DEV_SERVER" 

  local existing_php_term
  if toggleterm_module.get_term then
    existing_php_term = toggleterm_module.get_term(function(term)
      return term.display_name == PHP_SERVER_TERM_NAME
    end)
  end
  
  if existing_php_term then
    if existing_php_term:is_running() then
      vim.notify("Servidor PHP ya está corriendo.", vim.log.levels.INFO, { title = "PHP Server" })
      if open_browser_cmd_string then
          vim.notify("Intentando abrir/refrescar: " .. server_url, vim.log.levels.INFO, { title = "PHP Server" })
          vim.fn.system(open_browser_cmd_string .. " > /dev/null 2>&1 &")
      end
      existing_php_term:open()
    else
      vim.notify("Terminal de servidor PHP encontrada pero no corriendo. Reiniciando...", vim.log.levels.INFO, { title = "PHP Server" })
      existing_php_term:set_cmd(php_server_cmd)
      existing_php_term:set_dir(project_root)
      existing_php_term:open()
      if open_browser_cmd_string then
        vim.defer_fn(function()
            vim.notify("Abriendo navegador (reinicio): " .. server_url, vim.log.levels.INFO, { title = "PHP Server" })
            vim.fn.system(open_browser_cmd_string .. " > /dev/null 2>&1 &")
        end, 1500)
      end
    end
    return
  end

  vim.notify("Iniciando nuevo Servidor PHP en " .. project_root, vim.log.levels.INFO, { title = "PHP Server" })
  local term_instance = Terminal_constructor:new({
    cmd = php_server_cmd, 
    dir = project_root,
    direction = "float",
    hidden = false,
    close_on_exit = true,
    display_name = PHP_SERVER_TERM_NAME,
    on_open = function(term)
      vim.notify("Servidor PHP iniciado. Logs visibles aquí.", vim.log.levels.INFO, { title = "PHP Server" })
      if open_browser_cmd_string then
        vim.defer_fn(function()
            vim.notify("Abriendo navegador: " .. server_url, vim.log.levels.INFO, { title = "PHP Server" })
            vim.fn.system(open_browser_cmd_string .. " > /dev/null 2>&1 &") 
        end, 1500) 
      end
    end,
    on_close = function()
      vim.notify("Servidor PHP detenido.", vim.log.levels.INFO, { title = "PHP Server" })
    end
  })
  term_instance:open()
end

vim.keymap.set('n', '<leader>osp', start_php_server_and_open_browser, { desc = "Open PHP Server & Browser (ToggleTerm)" })
-- >>> FIN: NUEVO MAPEO PARA SERVIDOR PHP <<<
