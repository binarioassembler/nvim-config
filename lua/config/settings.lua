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
