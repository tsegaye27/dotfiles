-- ============================================================================
-- Neovim Settings Configuration
-- ============================================================================
-- This file contains all Neovim options and settings.
-- It's loaded early in the initialization process.
-- ============================================================================

---@diagnostic disable: undefined-global
-- Clipboard integration: use system clipboard for all operations
vim.opt.clipboard = "unnamedplus"
-- Completion menu options
vim.opt.completeopt = "menu,menuone,noselect"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.showmode = false
vim.opt.title = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "⟩", precedes = "⟨" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*", "*/dist/*" })
vim.opt.formatoptions:append({ "r" })

-- Folding settings using Treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "1"

-- Custom fold text function for a cleaner look
---@diagnostic disable: undefined-field
function _G.custom_foldtext()
	local line = vim.fn.getline(vim.v.foldstart):gsub("[\t]", " ")
	local fold_size = vim.v.foldend - vim.v.foldstart + 1
	local fold_marker = ""
	local text = string.format("%s %s (%d lines)", fold_marker, vim.trim(line), fold_size)
	local width = vim.fn.winwidth(0) - vim.fn.strwidth(vim.opt.foldcolumn:get()) - 1
	local truncated_text = vim.fn.strcharpart(text, 0, width)
	return truncated_text
end

---@diagnostic enable: undefined-field

vim.opt.foldtext = "v:lua.custom_foldtext()"

-- Use Catppuccin fold characters if available, otherwise fallback
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
-- Persistent undo
local undo_dir = vim.fn.stdpath("data") .. "/undodir"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true

vim.g.have_nerd_font = true
