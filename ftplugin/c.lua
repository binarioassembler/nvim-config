-- ~/.config/nvim/ftplugin/c.lua
-- vim.notify("INTENTO DE CARGA: ftplugin/c.lua - Filetype buffer: " .. vim.bo.filetype, vim.log.levels.ERROR, {title = "DIAGNÓSTICO INICIAL"})

if vim.bo.filetype ~= 'c' then
  -- vim.notify("GUARDA C: No es filetype 'c' (es '" .. vim.bo.filetype .. "'), saliendo de ftplugin/c.lua.", vim.log.levels.ERROR, {title = "C DEBUG"})
  return
end

-- vim.notify("GUARDA C: Filetype ES 'c', procediendo en ftplugin/c.lua.", vim.log.levels.ERROR, {title = "C DEBUG"})

vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

local function compile_and_run_c_toggleterm()
  vim.cmd('write')
  local current_file_fullpath = vim.fn.expand('%:p')
  local executable_name_base = vim.fn.expand('%:t:r')
  local file_dir = vim.fn.expand('%:p:h')
  local executable_fullpath = file_dir .. "/" .. executable_name_base

  -- vim.notify("FUNCIÓN C: compile_and_run_c_toggleterm LLAMADA. Filetype buffer: " .. vim.bo.filetype, vim.log.levels.ERROR, {title = "C DEBUG"})

  local compile_flags_c = "-std=c11 -Wall -Wextra -pedantic"
  local command_to_run_c = string.format(
    "if gcc %s %s -o %s; then clear; %s; echo ''; echo '--- Ejecución finalizada. ---'; else echo ''; echo '--- COMPILACIÓN FALLIDA ---'; fi; echo ''; echo 'Presiona tecla Enter.'; read -n 1 -s -r",
    compile_flags_c,
    vim.fn.shellescape(current_file_fullpath),
    vim.fn.shellescape(executable_fullpath),
    vim.fn.shellescape(executable_fullpath)
  )
  -- vim.notify("FUNCIÓN C: Comando construido: " .. command_to_run_c, vim.log.levels.ERROR, {title = "C DEBUG"})

  local command_to_run = command_to_run_c

  local toggleterm_module = require("toggleterm")
  if not toggleterm_module or not toggleterm_module.Terminal then
    local tt_setup_ok, toggleterm_setup = pcall(require, "toggleterm.terminal")
    if not tt_setup_ok or not toggleterm_setup or not toggleterm_setup.Terminal then
        -- vim.notify("toggleterm.nvim o su módulo Terminal no está disponible.", vim.log.levels.ERROR, {title = "C DEBUG"})
        vim.api.nvim_err_writeln("Error: toggleterm.nvim no está disponible para ftplugin/c.lua")
        return
    else
        toggleterm_module = toggleterm_setup
    end
  end
  local term = toggleterm_module.Terminal:new({
    cmd = command_to_run,
    dir = file_dir,
    direction = "float",
    hidden = true,
    id = 1002,
    on_open = function(opened_term)
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "t", "<Esc>", "<C-\\><C-n><cmd>close<CR>", { noremap = true, silent = true })
    end,
    autoclose = true,
  })
  term:toggle()
end
vim.keymap.set('n', '<leader>rt', compile_and_run_c_toggleterm, { buffer = true, noremap = true, silent = true, desc = "Compile & Run C (ToggleTerm)" })

local function compile_only_c_toggleterm()
  vim.cmd('write')
  local current_file_fullpath = vim.fn.expand('%:p')
  local executable_name_base = vim.fn.expand('%:t:r')
  local file_dir = vim.fn.expand('%:p:h')
  local executable_fullpath = file_dir .. "/" .. executable_name_base

  -- vim.notify("FUNCIÓN C: compile_only_c_toggleterm LLAMADA. Filetype buffer: " .. vim.bo.filetype, vim.log.levels.ERROR, {title = "C DEBUG"})
  
  local compile_flags_c = "-std=c11 -Wall -Wextra -pedantic"
  local command_to_run_c_only = string.format(
    "if gcc %s %s -o %s; then echo 'Compilación de %s exitosa!'; else echo 'Error: compilación de %s fallida.'; fi; echo ''; echo 'Presiona cualquier tecla para cerrar esta ventana.'; read -n 1 -s -r",
    compile_flags_c,
    vim.fn.shellescape(current_file_fullpath),
    vim.fn.shellescape(executable_fullpath),
    vim.fn.basename(current_file_fullpath),
    vim.fn.basename(current_file_fullpath)
  )
  -- vim.notify("FUNCIÓN C: Comando (solo compilar) construido: " .. command_to_run_c_only, vim.log.levels.ERROR, {title = "C DEBUG"})
  
  local command_to_run = command_to_run_c_only

  local toggleterm_module = require("toggleterm")
  if not toggleterm_module or not toggleterm_module.Terminal then
    local tt_setup_ok, toggleterm_setup = pcall(require, "toggleterm.terminal")
    if not tt_setup_ok or not toggleterm_setup or not toggleterm_setup.Terminal then
        -- vim.notify("toggleterm.nvim o su módulo Terminal no está disponible.", vim.log.levels.ERROR, {title = "C DEBUG"})
        vim.api.nvim_err_writeln("Error: toggleterm.nvim no está disponible para ftplugin/c.lua")
        return
    else
        toggleterm_module = toggleterm_setup
    end
  end
  local term = toggleterm_module.Terminal:new({
    cmd = command_to_run,
    dir = file_dir,
    direction = "float",
    hidden = true,
    id = 1004,
    on_open = function(opened_term)
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "t", "<Esc>", "<C-\\><C-n><cmd>close<CR>", { noremap = true, silent = true })
    end,
    autoclose = true,
  })
  term:toggle()
end
vim.keymap.set('n', '<leader>rC', compile_only_c_toggleterm, { buffer = true, noremap = true, silent = true, desc = "Compile Only C (ToggleTerm)" })

-- vim.notify("FIN DE CARGA: ftplugin/c.lua", vim.log.levels.ERROR, {title = "DIAGNÓSTICO FINAL"})
