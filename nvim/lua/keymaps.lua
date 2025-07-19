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
map("i", "jk", "<Esc>", opts) -- Fast exit from insert mode
map("i", "kj", "<Esc>", opts) -- Fast exit from insert mode
map("n", "Y", "y$", { desc = "Yank to end of line" }) -- Make Y behave consistently

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
		end, -- Use stopinsert on close
	})
	lazygit:toggle()
end, { desc = "[G]it [G]UI (Lazygit)" })

-- Emmet trigger (if needed explicitly, often handled by completion)
-- map('i', '<C-y>,', '<C-y>,', { desc = 'Trigger Emmet' })

-- Treesitter Textobjects (Examples - see Treesitter config for more)
-- map('o', 'if', ':<C-U>lua require("nvim-treesitter.textobjects.select").select_textobject("@function.inner")<CR>', { desc = 'Select inner function' })
-- map('x', 'if', ':<C-U>lua require("nvim-treesitter.textobjects.select").select_textobject("@function.inner")<CR>', { desc = 'Select inner function' })

-- ToggleTerm mapping (defined in opts, but could be here too)
-- map('n', '<c-\>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle Terminal' })
