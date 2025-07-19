vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "" -- Disable mouse for speed
vim.opt.showmode = false
vim.opt.title = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250 -- Faster update time
vim.opt.timeoutlen = 300 -- Faster key sequence timeout
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
vim.opt.formatoptions:append({ "r" }) -- Auto-format comments

-- Folding settings using Treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99 -- Start with folds open
vim.opt.foldenable = true
vim.opt.foldcolumn = "1" -- Show fold indicator in sign column

-- Custom fold text function for a cleaner look
function _G.custom_foldtext()
	local line = vim.fn.getline(vim.v.foldstart):gsub("[\t]", " ") -- Replace tabs with spaces
	local fold_size = vim.v.foldend - vim.v.foldstart + 1
	local fold_marker = "" -- Use a Nerd Font icon
	local text = string.format("%s %s (%d lines)", fold_marker, vim.trim(line), fold_size)
	local width = vim.fn.winwidth(0) - vim.fn.strwidth(vim.opt.foldcolumn:get()) - 1
	local truncated_text = vim.fn.strcharpart(text, 0, width)
	return truncated_text
end
vim.opt.foldtext = "v:lua.custom_foldtext()"

-- Use Catppuccin fold characters if available, otherwise fallback
vim.opt.fillchars = {
	foldopen = vim.g.catppuccin_flavour == "mocha" and "" or "",
	foldclose = vim.g.catppuccin_flavour == "mocha" and "" or "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ", -- Hide end-of-buffer tildes
}

-- Persistent undo
local undo_dir = vim.fn.stdpath("data") .. "/undodir"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "p")
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true

vim.g.have_nerd_font = true -- Assuming you have Nerd Fonts installed
