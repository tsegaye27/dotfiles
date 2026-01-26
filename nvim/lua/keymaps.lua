---@diagnostic disable: undefined-global
-- ============================================================================
-- Key Mappings Configuration
-- ============================================================================
-- This file contains all custom key mappings.
-- Leader key is set to <Space> in init.lua
-- ============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window Navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- File Operations
map({ "n", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>a", { desc = "Save file" })
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit Neovim" })
map("n", "<C-S-q>", "<cmd>qa!<CR>", { desc = "Force Quit Neovim" })

-- Editing Enhancements
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)
map("n", "Y", "y$", { desc = "Yank to end of line" })

-- Folding
map("n", "zo", "zo", { desc = "Open fold" })
map("n", "zc", "zc", { desc = "Close fold" })
map("n", "za", "za", { desc = "Toggle fold" })
map("n", "zR", "zR", { desc = "Open all folds" })
map("n", "zM", "zM", { desc = "Close all folds" })

-- Plugin Keymaps (Examples - some are defined in init.lua within plugin configs)
map("n", "<leader>sR", function()
	require("spectre").open()
end, { desc = "[S]earch and [R]eplace in files (Spectre)" })

map("n", "<leader>gg", function()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.fn.getcwd(),
		hidden = true,
		direction = "float",
		float_opts = { border = "curved" },
		on_open = function(_)
			vim.cmd("startinsert!")
		end,
		on_close = function(_)
			vim.cmd("stopinsert!")
		end,
	})
	lazygit:toggle()
end, { desc = "[G]it [G]UI (Lazygit)" })
