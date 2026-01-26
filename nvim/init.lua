-- ============================================================================
-- Neovim Configuration
-- ============================================================================
-- This is the main entry point for the Neovim configuration.
-- It sets up the plugin manager and loads all plugins with their configurations.
--
-- Structure:
--   1. Leader key setup
--   2. Load core settings and keymaps
--   3. Bootstrap lazy.nvim plugin manager
--   4. Configure all plugins
-- ============================================================================

---@diagnostic disable: undefined-global
-- Set leader and local leader keys
-- Leader key is used as a prefix for custom keybindings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration modules
require("settings") -- Neovim options and settings
require("keymaps")  -- Custom key mappings

-- ============================================================================
-- Bootstrap lazy.nvim Plugin Manager
-- ============================================================================
-- Automatically installs lazy.nvim if it's not already installed.
-- This allows the configuration to work on fresh systems without manual setup.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Error cloning lazy.nvim: " .. out)
	end
end
vim.opt.rtp:prepend(lazypath) -- Add lazy.nvim to runtime path

-- ============================================================================
-- Plugin Configuration
-- ============================================================================
-- All plugins are configured here using lazy.nvim.
-- Plugins are lazy-loaded by default for optimal performance.
-- ============================================================================

require("lazy").setup({
	-- ========================================================================
	-- Colorscheme: Catppuccin
	-- ========================================================================
	-- A beautiful, customizable colorscheme with multiple flavours.
	-- Loaded immediately (lazy = false) to avoid flash of unstyled content.
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Load first
		lazy = false, -- Load immediately
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = true,
					mini = true,
					lsp_trouble = true,
					mason = true,
					treesitter = true,
					indent_blankline = {
						enabled = true,
						scope_color = "overlay1",
					},
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")

			vim.opt.fillchars.foldopen = ""
			vim.opt.fillchars.foldclose = ""
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		priority = 1000,
		build = ":TSUpdate",
		config = function()
			vim.defer_fn(function()
				local ok, configs = pcall(require, "nvim-treesitter.configs")
				if ok then
					configs.setup({
						ensure_installed = { "lua", "vim", "vimdoc", "query", "bash", "c", "python", "go", "javascript", "typescript", "tsx", "html", "css", "vue", "json", "yaml", "markdown" },
						sync_install = false,
						auto_install = true,
						highlight = { enable = true },
						indent = { enable = true },
						incremental_selection = {
							enable = true,
							keymaps = {
								init_selection = "<c-space>",
								node_incremental = "<c-space>",
								scope_incremental = "<c-s>",
								node_decremental = "<M-space>",
							},
						},
					})
				else
					vim.notify("nvim-treesitter.configs not ready yet – will retry next startup",
						vim.log.levels.WARN)
				end
			end, 0)
		end,
	},

	-- ========================================================================
	-- Editor Enhancements
	-- ========================================================================
	-- Automatically adjusts 'shiftwidth' and 'expandtab' based on file type.
	{ "tpope/vim-sleuth",     event = "BufReadPost" },

	-- ========================================================================
	-- Git Integration: Gitsigns
	-- ========================================================================
	-- Shows git signs in the sign column and provides git-related keybindings.
	-- Features: blame, diff, stage/reset hunks, and more.
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, lhs, rhs, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, lhs, rhs, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Next hunk" })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Previous hunk" })

					-- Actions
					map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>",
						{ desc = "Stage hunk" })
					map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>",
						{ desc = "Reset hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame line" })
					map("n", "<leader>tb", gs.toggle_current_line_blame,
						{ desc = "Toggle blame line" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "Diff this ~" })
					map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
				end,
			})
		end,
	},
	-- ========================================================================
	-- Go Development: go.nvim
	-- ========================================================================
	-- Enhanced Go development experience with auto-formatting on save.
	-- Automatically formats Go files using gofumpt before saving.
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			gofmt = "gofumpt", -- Use gofumpt for stricter formatting
		},
		config = function(lp, opts)
			require("go").setup(opts)
			-- Auto-format Go files on save
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").gofmt()
				end,
				group = format_sync_grp,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()',
	},

	-- ========================================================================
	-- HTML/CSS: Emmet
	-- ========================================================================
	-- Expands HTML/CSS abbreviations (e.g., div>ul>li becomes full HTML).
	-- Trigger with <C-y>, in insert mode.
	{
		"mattn/emmet-vim",
		ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
		init = function()
			vim.g.user_emmet_mode = "a"
			vim.g.user_emmet_leader_key = "<C-y>"
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				plugins = {
					marks = true,
					registers = true,
					spelling = { enabled = true },
					presets = {
						operators = true,
						motions = true,
						text_objects = true,
						windows = true,
						nav = true,
						z = true,
						g = true,
					},
				},
				window = {
					border = "rounded",
					margin = { 1, 0, 1, 0 },
					padding = { 2, 2, 2, 2 },
				},
				layout = {
					height = { min = 4, max = 25 },
					width = { min = 20, max = 50 },
					spacing = 3,
					align = "left",
				},
				ignore_missing = true,
				show_help = true,
				triggers = "auto",
				delay = 50,
			})

			wk.register({
				["<leader>"] = {
					f = { name = "[F]ormat/File" },
					s = { name = "[S]earch" },
					g = { name = "[G]it" },
					e = { name = "[E]xplorer" },
					r = { name = "[R]ename/Replace" },
					c = { name = "[C]ode" },
					d = { name = "[D]iagnostic" },
				},
			})
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
		},
		config = function()
			require("nvim-tree").setup({
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true,
				},
				filters = {
					dotfiles = false,
					custom = { "^.git$" },
				},
				renderer = {
					root_folder_label = false,
					indent_markers = {
						enable = true,
					},
					icons = {
						webdev_colors = true,
						git_placement = "before",
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
						glyphs = {
							default = "",
							symlink = "",
							folder = {
								arrow_open = "",
								arrow_closed = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								unstaged = "",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
						},
					},
				},
				view = {
					width = 30,
					side = "left",
				},
			})
		end,
	},
	-- { "wakatime/vim-wakatime", event = "VeryLazy" },
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_filetypes = {
				["*"] = true,
			}

			-- Tab accepts Copilot suggestion, falls back to normal Tab
			vim.keymap.set("i", "<Tab>", function()
				if vim.fn["copilot#Accept"]() ~= "" then
					return vim.fn["copilot#Accept"]()
				else
					return "<Tab>"
				end
			end, { expr = true, silent = true, desc = "Accept Copilot or insert Tab" })
		end,
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		event = "VeryLazy",
		init = function()
			vim.g.vm_leader = "<leader>"
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPost",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = true,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 3000,
					lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
			},
		},
	},

	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "html", "javascriptreact", "typescriptreact", "vue", "svelte", "xml", "php" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "catppuccin",
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "nvim-tree", "toggleterm", "mason" },
		},
	},

	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gcc", "gbc" },
		opts = {},
	},

	-- ========================================================================
	-- Auto-pairs: nvim-autopairs
	-- ========================================================================
	-- Automatically closes brackets, quotes, etc.
	-- Integrated with nvim-cmp for better completion experience.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({})

			-- Integrate with cmp for better completion experience
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- ========================================================================
	-- Fuzzy Finder: Telescope
	-- ========================================================================
	-- Powerful fuzzy finder for files, buffers, grep, and more.
	-- Extensions: fzf-native (faster), ui-select (better UI)
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
		},
		keys = {
			{
				"<leader>sh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "[S]earch [H]elp",
			},
			{
				"<leader>sk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "[S]earch [K]eymaps",
			},
			{
				"<leader>sf",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "[S]earch [F]iles",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").builtin()
				end,
				desc = "[S]earch [S]elect Telescope",
			},
			{
				"<leader>sw",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "[S]earch current [W]ord",
			},
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "[S]earch by [G]rep",
			},
			{
				"<leader>sd",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "[S]earch [D]iagnostics",
			},
			{
				"<leader>sr",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "[S]earch [R]esume",
			},
			{
				"<leader>s.",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = '[S]earch Recent Files ("." for repeat)',
			},
			{
				"<leader><leader>",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "[ ] Find existing buffers",
			},
			{
				"<leader>/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find(require(
					"telescope.themes").get_dropdown({
						previewer = false,
					}))
				end,
				desc = "[/] Fuzzily search in current buffer",
			},
			-- {
			-- 	"<leader>s/",
			-- 	function()
			-- 		require("telescope.builtin").live_grep({
			-- 			grep_open_files = true,
			-- 			prompt_title = "Live Grep in Open Files",
			-- 		})
			-- 	end,
			-- 	desc = "[S]earch [/] in Open Files",
			-- },
			{
				"<leader>sn",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[S]earch [N]eovim files",
			},
		},
		config = function()
			require("telescope").setup({
				defaults = {
					path_display = { "truncate" },
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
					},
					sorting_strategy = "ascending",
					winblend = 10, -- Catppuccin uses 10
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
		end,
	},

	-- ========================================================================
	-- LSP: Mason - Language Server Installer
	-- ========================================================================
	-- Mason automatically installs and manages LSP servers, DAP adapters,
	-- linters, and formatters. This makes it easy to get language support
	-- without manual installation.
	-- ========================================================================
	-- LSP: Mason - Language Server Installer
	-- ========================================================================
	-- Mason automatically installs and manages LSP servers, DAP adapters,
	-- linters, and formatters. This makes it easy to get language support
	-- without manual installation.
	-- Note: setup() is called in nvim-lspconfig config to ensure proper order
	{
		"williamboman/mason.nvim",
		cmd = "Mason", -- Only load when :Mason command is used
		opts = {
			-- Pre-install commonly used tools
			ensure_installed = { "prettier", "stylua", "eslint", "eslint_d", "pyright", "gopls", "clangd" },
		},
		-- Don't call setup() here - it's called in lspconfig config
	},

	-- ========================================================================
	-- LSP: nvim-lspconfig - Language Server Protocol Configuration
	-- ========================================================================
	-- Configures Neovim's native LSP client to work with various language servers.
	-- Uses the new Neovim 0.11+ native LSP API (vim.lsp.config).
	-- Supports: TypeScript, Python, Lua, Go, C/C++, Vue, HTML/CSS, and more.
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },
		},
		config = function()
			-- Setup mason first
			require("mason").setup()

			-- Important: disable automatic lsp server enabling to avoid the 'enable' nil error
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ts_ls",
					"clangd",
					"html",
					"cssls",
					"tailwindcss",
					"vue_ls",
					"emmet_ls",
					"gopls",
				},
				automatic_installation = true,
				automatic_enable = false, -- ← this line fixes the crash
			})

			-- Shared capabilities + on_attach
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities,
				require("cmp_nvim_lsp").default_capabilities())

			local on_attach = function(client, bufnr)
				-- Disable formatting for servers handled by conform.nvim
				if client.name == "ts_ls" or client.name == "pyright" or client.name == "vue_ls" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				local function bufmap(keys, fn, desc)
					vim.keymap.set("n", keys, fn, {
						buffer = bufnr,
						silent = true,
						noremap = true,
						desc = "LSP: " .. desc,
					})
				end

				bufmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				bufmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				bufmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				bufmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
				bufmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				bufmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				bufmap("K", vim.lsp.buf.hover, "Hover Documentation")
				bufmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
				bufmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
				bufmap("<leader>dl", vim.diagnostic.setloclist, "Open diagnostic list")
				bufmap("<leader>df", vim.diagnostic.open_float, "Open floating diagnostic")
				bufmap("<leader>lf", function()
					vim.lsp.buf.format({ async = true })
				end, "[L]SP [F]ormat")

				if client.name == "ts_ls" then
					bufmap("<leader>oi", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.organizeImports" } },
							apply = true,
						})
					end, "[O]rganize [I]mports")

					bufmap("<leader>ru", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.removeUnused" } },
							apply = true,
						})
					end, "[R]emove [U]nused Imports")
				end
			end

			-- Manual configuration for each server (your original setup)
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
							disable = { "undefined-global" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("ts_ls", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.enable("ts_ls")

			vim.lsp.config("clangd", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.enable("clangd")

			vim.lsp.config("pyright", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.enable("pyright")

			vim.lsp.config("gopls", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
							nilness = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})
			vim.lsp.enable("gopls")

			local other_servers = { "html", "cssls", "tailwindcss", "vue_ls", "emmet_ls" }
			for _, server in ipairs(other_servers) do
				vim.lsp.config(server, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
				vim.lsp.enable(server)
			end
		end,
	},
	-- ========================================================================
	-- Completion: nvim-cmp
	-- ========================================================================
	-- Advanced completion engine with multiple sources:
	-- - LSP completions
	-- - Snippets (LuaSnip)
	-- - Buffer words
	-- - File paths
	-- - Command line completions
	-- Integrates with Copilot for Tab key handling.
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- Load when entering insert mode
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					-- Tab for Copilot, Ctrl+j/k for CMP navigation when CMP is open
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback() -- Let Copilot handle Tab
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						vim_item.kind = require("lspkind").presets.default[vim_item.kind] ..
						" " .. vim_item.kind
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
						})[entry.source.name]
						return vim_item
					end,
				},
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	{ "onsails/lspkind.nvim", event = "VeryLazy" },
	-- ========================================================================
	-- Cursor Animation: Smear Cursor
	-- ========================================================================
	-- Creates a trailing smear effect when the cursor moves for better visual tracking.
	{
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		opts = {
			smear_between_buffers = true,
			smear_between_neighbor_lines = true,
			scroll_buffer_space = true,
			smear_insert_mode = true,
		},
		config = function(_, opts)
			require("smear_cursor").setup(opts)
			require("smear_cursor").enabled = true
		end,
	},
	{
		"karb94/neoscroll.nvim",
		keys = {
			{
				"<C-u>",
				function()
					require("neoscroll").scroll(-vim.wo.scroll,
						{ duration = 200, easing = "quadratic" })
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Scroll Up Half Page (Smooth)",
			},
			{
				"<C-d>",
				function()
					require("neoscroll").scroll(vim.wo.scroll,
						{ duration = 200, easing = "quadratic" })
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Scroll Down Half Page (Smooth)",
			},
			{
				"<C-b>",
				function()
					require("neoscroll").scroll(
						-vim.api.nvim_win_get_height(0),
						{ duration = 200, easing = "quadratic" }
					)
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Scroll Up Full Page (Smooth)",
			},
			{
				"<C-f>",
				function()
					require("neoscroll").scroll(
						vim.api.nvim_win_get_height(0),
						{ duration = 200, easing = "quadratic" }
					)
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Scroll Down Full Page (Smooth)",
			},
			{
				"<C-u>",
				function()
					require("neoscroll").scroll(-vim.wo.scroll,
						{ duration = 200, easing = "quadratic" })
				end,
				mode = "v",
				noremap = true,
				silent = true,
				desc = "Scroll Up Half Page (Smooth)",
			},
			{
				"<C-d>",
				function()
					require("neoscroll").scroll(vim.wo.scroll,
						{ duration = 200, easing = "quadratic" })
				end,
				mode = "v",
				noremap = true,
				silent = true,
				desc = "Scroll Down Half Page (Smooth)",
			},
			{
				"<C-b>",
				function()
					require("neoscroll").scroll(
						-vim.api.nvim_win_get_height(0),
						{ duration = 200, easing = "quadratic" }
					)
				end,
				mode = "v",
				noremap = true,
				silent = true,
				desc = "Scroll Up Full Page (Smooth)",
			},
			{
				"<C-f>",
				function()
					require("neoscroll").scroll(
						vim.api.nvim_win_get_height(0),
						{ duration = 200, easing = "quadratic" }
					)
				end,
				mode = "v",
				noremap = true,
				silent = true,
				desc = "Scroll Down Full Page (Smooth)",
			},
		},
	},


	{
		"akinsho/toggleterm.nvim",
		version = "*",
		-- cmd = 'ToggleTerm',
		keys = {
			{ "<c-\\>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle Terminal" },
		},
		opts = {
			-- open_mapping = [[<c-\>]],
			direction = "float",
			float_opts = {
				border = "curved",
			},
		},
	},
})
