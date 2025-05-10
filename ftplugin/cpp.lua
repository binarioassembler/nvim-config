-- ~/.config/nvim/ftplugin/cpp.lua
-- Puedes mantener la guarda de filetype si lo deseas, o quitarla si solo quedan los mapeos.
-- if vim.bo.filetype ~= 'cpp' then
--   return
-- end

-- Las opciones de indentación ahora son globales y se establecen en lua/config/settings.lua.

local function compile_and_run_cpp_toggleterm()
  vim.cmd('write')

  local current_file_fullpath = vim.fn.expand('%:p')
  local executable_name_base = vim.fn.expand('%:t:r')
  local file_dir = vim.fn.expand('%:p:h')
  local executable_fullpath = file_dir .. "/" .. executable_name_base
  
  local compile_flags_cpp = "-std=c++17 -Wall -Wextra -pedantic"
  local command_to_run_cpp = string.format(
    "if g++ %s %s -o %s; then clear; %s; echo ''; echo '--- Ejecución finalizada. ---'; else echo ''; echo '--- COMPILACIÓN FALLIDA ---'; fi; echo ''; echo 'Presiona Enter.'; read -n 1 -s -r",
    compile_flags_cpp,
    vim.fn.shellescape(current_file_fullpath),
    vim.fn.shellescape(executable_fullpath),
    vim.fn.shellescape(executable_fullpath)
  )

  local command_to_run = command_to_run_cpp

  local toggleterm_module = require("toggleterm")
  if not toggleterm_module or not toggleterm_module.Terminal then
    local tt_setup_ok, toggleterm_setup = pcall(require, "toggleterm.terminal")
    if not tt_setup_ok or not toggleterm_setup or not toggleterm_setup.Terminal then
        vim.api.nvim_err_writeln("Error: toggleterm.nvim no está disponible para ftplugin/cpp.lua")
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
    id = 1001, -- Asegúrate de que este ID sea único
    on_open = function(opened_term)
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "t", "<Esc>", "<C-\\><C-n><cmd>close<CR>", { noremap = true, silent = true })
    end,
    autoclose = true,
  })
  term:toggle()
end
vim.keymap.set('n', '<leader>rt', compile_and_run_cpp_toggleterm, { buffer = true, noremap = true, silent = true, desc = "Compile & Run C++ (ToggleTerm)" })

local function compile_only_cpp_toggleterm()
  vim.cmd('write')
  local current_file_fullpath = vim.fn.expand('%:p')
  local executable_name_base = vim.fn.expand('%:t:r')
  local file_dir = vim.fn.expand('%:p:h')
  local executable_fullpath = file_dir .. "/" .. executable_name_base

  local compile_flags_cpp = "-std=c++17 -Wall -Wextra -pedantic"
  local command_to_run_cpp_only = string.format(
    "if g++ %s %s -o %s; then echo 'Compilación de %s exitosa!'; else echo 'Error: compilación de %s fallida.'; fi; echo ''; echo 'Presiona cualquier tecla para cerrar esta ventana.'; read -n 1 -s -r",
    compile_flags_cpp,
    vim.fn.shellescape(current_file_fullpath),
    vim.fn.shellescape(executable_fullpath),
    vim.fn.basename(current_file_fullpath),
    vim.fn.basename(current_file_fullpath)
  )
  
  local command_to_run = command_to_run_cpp_only

  local toggleterm_module = require("toggleterm")
  if not toggleterm_module or not toggleterm_module.Terminal then
    local tt_setup_ok, toggleterm_setup = pcall(require, "toggleterm.terminal")
    if not tt_setup_ok or not toggleterm_setup or not toggleterm_setup.Terminal then
        vim.api.nvim_err_writeln("Error: toggleterm.nvim no está disponible para ftplugin/cpp.lua")
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
    id = 1003, -- Asegúrate de que este ID sea único
    on_open = function(opened_term)
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "t", "<Esc>", "<C-\\><C-n><cmd>close<CR>", { noremap = true, silent = true })
    end,
    autoclose = true,
  })
  term:toggle()
end
vim.keymap.set('n', '<leader>rC', compile_only_cpp_toggleterm, { buffer = true, noremap = true, silent = true, desc = "Compile Only C++ (ToggleTerm)" })
