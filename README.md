# ✨ Mi Configuración de NeoVim ~ 2025 ✨

Esta es la configuración base de mi terminal en NeoVim, ¡en constante evolución hacia la perfección!

## 🌳 Distribución de Archivos

> Así se organizan las piezas de este rompecabezas:

*   📂 **ftplugin**
    *   📄 `c.lua`
    *   📄 `cpp.lua`
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
        *   📄 `dap.lua`
        *   📄 `fugitive.lua`
        *   📄 `gitsigns.lua`
        *   📄 `lsp.lua`
        *   📄 `lualine.lua`
        *   📄 `luasnip.lua`
        *   📄 `mason.lua`
        *   📄 `none-ls.lua`
        *   📄 `notify.lua`
        *   📄 `telescope.lua`
        *   📄 `terminal.lua`
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
--require("config.lazy") de la última versión
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
-- ~/.config/nvim/ftplugin/c.lua
-- ~/.config/nvim/ftplugin/c.lua
if vim.bo.filetype ~= 'c' then
  return
end

-- Las opciones de indentación ahora son globales y se establecen en lua/config/settings.lua.
-- Solo mantenemos aquí lo específico para C que NO sea indentación, como las funciones de compilación.

local function compile_and_run_c_toggleterm()
  vim.cmd('write')
  local current_file_fullpath = vim.fn.expand('%:p')
  local executable_name_base = vim.fn.expand('%:t:r')
  local file_dir = vim.fn.expand('%:p:h')
  local executable_fullpath = file_dir .. "/" .. executable_name_base

  local compile_flags_c = "-std=c11 -Wall -Wextra -pedantic"
  local command_to_run_c = string.format(
    "if gcc %s %s -o %s; then clear; %s; echo ''; echo '--- Ejecución finalizada. ---'; else echo ''; echo '--- COMPILACIÓN FALLIDA ---'; fi; echo ''; echo 'Presiona tecla Enter.'; read -n 1 -s -r",
    compile_flags_c,
    vim.fn.shellescape(current_file_fullpath),
    vim.fn.shellescape(executable_fullpath),
    vim.fn.shellescape(executable_fullpath)
  )

  local command_to_run = command_to_run_c

  local toggleterm_module = require("toggleterm")
  if not toggleterm_module or not toggleterm_module.Terminal then
    local tt_setup_ok, toggleterm_setup = pcall(require, "toggleterm.terminal")
    if not tt_setup_ok or not toggleterm_setup or not toggleterm_setup.Terminal then
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
    id = 1002, -- Asegúrate de que este ID sea único si tienes otros terminales definidos así
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
  
  local compile_flags_c = "-std=c11 -Wall -Wextra -pedantic"
  local command_to_run_c_only = string.format(
    "if gcc %s %s -o %s; then echo 'Compilación de %s exitosa!'; else echo 'Error: compilación de %s fallida.'; fi; echo ''; echo 'Presiona cualquier tecla para cerrar esta ventana.'; read -n 1 -s -r",
    compile_flags_c,
    vim.fn.shellescape(current_file_fullpath),
    vim.fn.shellescape(executable_fullpath),
    vim.fn.basename(current_file_fullpath),
    vim.fn.basename(current_file_fullpath)
  )
  
  local command_to_run = command_to_run_c_only

  local toggleterm_module = require("toggleterm")
  if not toggleterm_module or not toggleterm_module.Terminal then
    local tt_setup_ok, toggleterm_setup = pcall(require, "toggleterm.terminal")
    if not tt_setup_ok or not toggleterm_setup or not toggleterm_setup.Terminal then
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
    id = 1004, -- Asegúrate de que este ID sea único
    on_open = function(opened_term)
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(opened_term.bufnr, "t", "<Esc>", "<C-\\><C-n><cmd>close<CR>", { noremap = true, silent = true })
    end,
    autoclose = true,
  })
  term:toggle()
end
vim.keymap.set('n', '<leader>rC', compile_only_c_toggleterm, { buffer = true, noremap = true, silent = true, desc = "Compile Only C (ToggleTerm)" })
```

#### 📄 `ftplugin/cpp.lua`

Ajustes para archivos C++.

```lua
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
require "config.keymaps"
require "config.lazy"
```

##### 📄 `lua/config/keymaps.lua`

Definición de atajos de teclado globales y específicos.

```lua
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
```

##### 📄 `lua/config/lazy.lua`

Configuración del gestor de plugins `lazy.nvim`.

```lua
-- lua/config/lazy.lua

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
  install = { colorscheme = { "catppuccin" } }, -- MODIFICADO AQUÍ
  -- automatically check for plugin updates
  checker = { enabled = true },
})
```

##### 📄 `lua/config/settings.lua`

Configuraciones generales de Neovim (opciones).

```lua
-- lua/config/settings.lua
vim.o.number = true
vim.o.relativenumber = true
vim.g.mapleader = " "
vim.o.termguicolors = true

-- >>> INICIO: CONFIGURACIÓN DE INDENTACIÓN GLOBAL POR DEFECTO <<<
vim.opt.tabstop = 2       -- Número de espacios que representa un <Tab>
vim.opt.softtabstop = 2   -- Número de espacios para <Tab> y <Backspace> en modo inserción
vim.opt.shiftwidth = 2    -- Número de espacios para indentación automática (>>, <<)
vim.opt.expandtab = true  -- Usar espacios en lugar de caracteres Tab literales
vim.opt.autoindent = true -- Copiar indentación de la línea actual al crear una nueva
vim.opt.smartindent = true -- Hacer indentación más inteligente para algunos lenguajes (ej. C)
-- >>> FIN: CONFIGURACIÓN DE INDENTACIÓN GLOBAL POR DEFECTO <<<

-- Aquí podrían ir otras configuraciones globales que tengas o quieras añadir en el futuro.
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

##### 📄 `lua/config/plugins/luasnip.lua`

Configuración para `LuaSnip` (gestor de snippets).

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
  main = "config.plugins.cmp",
  config = true,
}
```

##### 📄 `lua/plugins/colorscheme.lua`

Plugin: `vim-catppuccin` (tema de colores).

```lua
-- lua/plugins/colorscheme.lua
return {
  "catppuccin/nvim",
  name = "catppuccin", -- Nombre para referenciarlo
  lazy = false,
  priority = 1000,    -- Asegura que se cargue temprano
  config = function()
    local flavour = "frappe" -- << CAMBIA AQUÍ TU FLAVOUR PREFERIDO: "latte", "frappe", "macchiato", "mocha"

    local status_ok, catppuccin = pcall(require, "catppuccin")
    if not status_ok then
      -- Puedes dejar esta notificación de error si quieres, por si el plugin falla en el futuro
      vim.notify("Catppuccin plugin (main module) not found. Please check installation.", vim.log.levels.ERROR)
      return
    end

    catppuccin.setup({
      flavour = flavour,
      transparent_background = false,
      term_colors = true,
      -- SIN SECCIÓN DE INTEGRATIONS POR AHORA
      -- styles = {
      --   comments = { "italic" },
      --   conditionals = { "italic" },
      -- },
    })

    vim.cmd.colorscheme("catppuccin-" .. flavour)

    -- Verificación silenciosa opcional, o simplemente confiar en que funciona
    -- if vim.g.colors_name == ("catppuccin-" .. flavour) then
    --   -- Todo bien
    -- else
    --   vim.notify("Failed to apply Catppuccin theme (Simple Setup). Current: " .. (vim.g.colors_name or "nil"), vim.log.levels.ERROR)
    -- end
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

##### 📄 `lua/plugins/dap.lua`

Plugin: `vim-dap` (mapeos para DAP).

```lua
-- lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dapui = require("dapui")
          dapui.setup({
            expand_lines = true,
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = { expand = { "<CR>", "<2-LeftMouse>" }, open = "o", remove = "d", edit = "e", repl = "r", toggle = "t" },
            layouts = {
              { elements = { { id = "scopes", size = 0.35 }, { id = "breakpoints", size = 0.20 }, { id = "stacks", size = 0.25 }, { id = "watches", size = 0.20 }, }, size = 40, position = "left" },
              { elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 }, }, size = 0.25, position = "bottom" },
            },
            floating = { max_height = nil, max_width = nil, border = "rounded", mappings = { close = { "q", "<Esc>" } } },
            windows = { indent = 1 },
            render = { max_type_length = nil, max_value_lines = 100 }
          })
          local dap_listeners = require("dap") 
          dap_listeners.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
          dap_listeners.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { commented = false },
      },
    },
    config = function()
      local dap = require("dap") 

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          stopOnEntry = false,
        },
      }

      -- >>> INICIO: MAPEOS PARA NVIM-DAP (MOVIDOS AQUÍ) <<<
      local dapui_ok, dapui = pcall(require, "dapui")

      vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = "DAP: Continue (<F5>)" })
      vim.keymap.set('n', '<leader>do', function() dap.step_over() end, { desc = "DAP: Step Over (<F10>)" })
      vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = "DAP: Step Into (<F11>)" })
      vim.keymap.set('n', '<leader>du', function() dap.step_out() end, { desc = "DAP: Step Out (Shift+<F11>)" })
      vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = "DAP: Toggle Breakpoint" })
      vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "DAP: Set Conditional Breakpoint" })
      vim.keymap.set('n', '<leader>dlp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "DAP: Set Log Point" })
      vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, { desc = "DAP: Open REPL" })
      vim.keymap.set('n', '<leader>dj', function() dap.run_last() end, { desc = "DAP: Run Last Config (Jump to)" })
      vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, { desc = "DAP: Terminate Session" })

      if dapui_ok then
        vim.keymap.set('n', '<leader>duu', function() dapui.toggle({}) end, { desc = "DAP: Toggle UI" })
        vim.keymap.set('n', '<leader>due', function() dapui.eval(vim.fn.input("Eval: ")) end, { desc = "DAP: Evaluate Expression (Input)"})
        vim.keymap.set('v', '<leader>due', function() dapui.eval() end, { desc = "DAP: Evaluate Visual Selection" })
        vim.keymap.set('n', '<leader>dus', function() dapui.open({reset=true}) end, { desc = "DAP: Open UI (Scopes)"})
      else
        vim.keymap.set({'n', 'v'}, '<leader>due', function() require('dap.ui.widgets').hover() end, { desc = "DAP: Hover/Evaluate (Fallback)" })
      end

      vim.keymap.set('n', '<leader>dsc', function()
        local configs = {}
        for _, config_type_table in pairs(dap.configurations) do
          if type(config_type_table) == "table" then
            for _, config_entry in ipairs(config_type_table) do
              table.insert(configs, config_entry.name .. " (type: " .. config_entry.type .. ")")
            end
          end
        end
        if #configs == 0 then vim.notify("DAP: No configurations found.", vim.log.levels.WARN); return end
        vim.ui.select(configs, { prompt = "Select DAP configuration:" }, function(choice)
          if not choice then return end
          local selected_name = string.match(choice, "^(.-)%s*%(")
          for _, config_type_table in pairs(dap.configurations) do
            if type(config_type_table) == "table" then
              for _, config_entry in ipairs(config_type_table) do
                if config_entry.name == selected_name then dap.run(config_entry); return end
              end
            end
          end
        end)
      end, { desc = "DAP: Select Configuration and Run" })
      -- >>> FIN: MAPEOS PARA NVIM-DAP <<<
      
      vim.notify("nvim-dap configurado y mapeos aplicados.", vim.log.levels.INFO, {title = "DAP Setup"})
    end,
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
  config = true,
}
```

##### 📄 `lua/plugins/none-ls.lua`

Plugin: `none-ls.nvim` (antes null-ls, para linters y formatters como fuentes LSP).

```lua
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
    -- this for transparency
    notify.setup { background_colour = "#000000" }
    -- this overwrites the vim notify function
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

##### 📄 `lua/plugins/terminal.lua`

Plugin: `toggleterm.nvim` (notificaciones mejoradas).

```lua
-- ~/.config/nvim/lua/plugins/terminal.lua
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
        return math.floor(vim.o.lines * 0.6)
      end,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = '75', -- Un valor más alto oscurece más los terminales inactivos
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      winbar = {
        enabled = false,
      },
      float_opts = {
        border = 'curved', -- O 'rounded', 'curved', 'single', etc.
        title = "Salida del Comando",
        title_pos = "center",
        width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        -- Referenciar los grupos de resaltado definidos en colorscheme.lua
        highlights = {
          border = "ToggleTermBorder",
          background = "ToggleTermFloatBg", -- Este será el fondo de la VENTANA flotante
          title = "ToggleTermTitle",
        },
      },
    },
    -- No es necesario un 'config' aquí si solo estamos usando 'opts'
    -- y los resaltados se definen externamente.
    -- Si la integración de Catppuccin para toggleterm (en colorscheme.lua) funciona,
    -- incluso podrías eliminar la sección 'highlights' de aquí y dejar que Catppuccin lo maneje.
  },
}
```

##### 📄 `lua/plugins/tree-sitter.lua`

Plugin: `nvim-treesitter` (mejor resaltado de sintaxis y más).

```lua
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
```

---

> 🚀 De momento estos son todos los archivos y plugins que se usan para esta configuración base de Neovim. ¡A seguir codeando!
