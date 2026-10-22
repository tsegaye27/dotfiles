vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.copilot_enabled = 0

require("settings")
require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Error cloning lazy.nvim: " .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				transparent_background = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = true,
					mini = true,
					lsp_trouble = true,
					mason = true,
					mini = { enabled = true },
					treesitter = true,
					indent_blankline = {
						enabled = false,
						scope_color = "overlay1", -- catppuccin color
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
					-- Add other integrations as needed
				},
			})
			vim.cmd.colorscheme("catppuccin-nvim")

			-- Update fillchars after colorscheme loads
			vim.opt.fillchars = {
				foldopen = "-",
				foldclose = "+",
				fold = "-",
				foldsep = "│",
				diff = "╱",
				eob = " ",
			}
		end,
	},

	{ "tpope/vim-sleuth", event = "BufReadPost" },

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
			})
		end,
	},

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
		opts = {
			delay = 50,
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		-- cmd = 'NvimTreeToggle',
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
						-- provider = 'nvim-web-devicons',
						glyphs = {
							default = "", --
							symlink = "", --
							folder = {
								arrow_open = "", --  (fa-chevron-down)
								arrow_closed = "", --  (fa-chevron-right)
								default = "", --
								open = "", --
								empty = "", --
								empty_open = "", --
								symlink = "", --
								symlink_open = "", --
							},
							git = {
								unstaged = "",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
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
				php = {},
				java = {},
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

	-- load devicons eagerly so icons work everywhere (nvim-tree, telescope, statusline)
	{ "nvim-tree/nvim-web-devicons", lazy = false },

	{
		"echasnovski/mini.statusline",
		version = false,
		lazy = false,
		config = function()
			local ms = require("mini.statusline")
			local L, R = "\u{e0b6}", "\u{e0b4}" -- rounded pill ends (Nerd Font)

			-- Transparent bar + pill colours from catppuccin
			local function set_hl()
				local c = require("catppuccin.palettes").get_palette("mocha")
				local hl = vim.api.nvim_set_hl
				hl(0, "StatusLine", { fg = c.text, bg = "NONE" })
				hl(0, "StatusLineNC", { fg = c.overlay0, bg = "NONE" })
				hl(0, "MiniStatuslineFilename", { fg = c.subtext0, bg = "NONE" })
				hl(0, "PillBody", { fg = c.text, bg = c.surface0 })
				hl(0, "PillEdge", { fg = c.surface0, bg = "NONE" })
				for _, m in ipairs({ "Normal", "Insert", "Visual", "Replace", "Command", "Other" }) do
					local bg = vim.api.nvim_get_hl(0, { name = "MiniStatuslineMode" .. m, link = false }).bg
					hl(0, "PillEdge" .. m, { fg = bg, bg = "NONE" })
				end
			end
			set_hl()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

			local function pill(body, edge, text)
				if text == nil or text == "" then
					return ""
				end
				return ("%%#%s#%s%%#%s# %s %%#%s#%s%%#StatusLine# "):format(edge, L, body, text, edge, R)
			end

			ms.setup({
				use_icons = true,
				content = {
					active = function()
						local mode, mode_hl = ms.section_mode({ trunc_width = 120 })
						local mode_edge = mode_hl:gsub("MiniStatuslineMode", "PillEdge")
						local vcs = vim.trim(
							ms.section_git({ trunc_width = 40 }) .. " " .. ms.section_diff({ trunc_width = 75 })
						)
						return table.concat({
							pill(mode_hl, mode_edge, mode),
							pill("PillBody", "PillEdge", vcs),
							"%#MiniStatuslineFilename#",
							ms.section_filename({ trunc_width = 140 }),
							"%=", -- transparent middle
							"%#StatusLine#",
							ms.section_diagnostics({ trunc_width = 75 }),
							" ",
							pill("PillBody", "PillEdge", ms.section_fileinfo({ trunc_width = 120 })),
							pill(mode_hl, mode_edge, ms.section_location({ trunc_width = 75 })),
						})
					end,
				},
			})
			vim.opt.laststatus = 3 -- global statusline
		end,
	},

	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gcc", "gbc" },
		opts = {},
	},

	-- 	{
	-- 		"edluffy/hologram.nvim",
	-- 		config = function()
	-- 			require("hologram").setup({
	-- 				auto_display = true,
	-- 			})
	-- 		end,
	-- 	},
	--
	-- {
	--     "samodostal/image.nvim",
	--     dependencies = {
	--         "nvim-lua/plenary.nvim"
	--     },
	--     config = function()
	--         require("image").setup()
	--     end
	-- },

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"nvim-pack/nvim-spectre",
		cmd = "Spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"nvim-telescope/telescope.nvim",
		-- cmd = 'Telescope',
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
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						previewer = false,
					}))
				end,
				desc = "[/] Fuzzily search in current buffer",
			},
			{
				"<leader>s/",
				function()
					require("telescope.builtin").live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end,
				desc = "[S]earch [/] in Open Files",
			},
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

	{
		"towolf/vim-helm",
		ft = { "helm", "yaml" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- mason.nvim
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ensure_installed = {
				"prettier",
				"stylua",
				"eslint",
				"eslint_d",
				"pyright",
				"gopls",
				"phpactor",
				-- "php_cs_fixer", -- Remove this line since we're not using it
				"jdtls",
				"java-debug-adapter",
				"java-test",
				"spring-boot-tools",
			},
		},
		config = function()
			require("mason").setup()
		end,
	},
	-- mason-lspconfig.nvim
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = false,
				automatic_enable = { enable = false },
			})
		end,
	},

	-- nvim-lspconfig
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
			-- ensure mason + mason-lspconfig are loaded
			require("mason").setup()
			require("mason-lspconfig").setup()

			local base_caps = vim.lsp.protocol.make_client_capabilities()
			local caps = vim.tbl_deep_extend("force", base_caps, require("cmp_nvim_lsp").default_capabilities())

			local on_attach = function(client, bufnr)
				local no_format = { ts_ls = true, pyright = true, vue_ls = true }
				if no_format[client.name] then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end
				-- jdtls manages its own formatter; don't let the fallback fight it
				-- (jdtls attaches via ftplugin, not this list, so nothing else to do here)
				-- helper to define buffer‐local keymaps
				local function bufmap(keys, fn, desc)
					vim.keymap.set("n", keys, fn, {
						buffer = bufnr,
						silent = true,
						noremap = true,
						desc = "LSP: " .. desc,
					})
				end

				-- your LSP keymaps
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

				-- ts‐ls specific code actions
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

			-- list the servers you want
			local servers = {
				"ts_ls",
				"pyright",
				"lua_ls",
				"html",
				"cssls",
				"tailwindcss",
				"vue_ls",
				"emmet_ls",
				"phpactor",
				"yamlls",
			}
			vim.lsp.config("yamlls", {
				capabilities = caps,
				on_attach = on_attach,
				settings = {
					yaml = {
						schemaStore = {
							enable = true,
							url = "https://www.schemastore.org/api/json/catalog.json",
						},
						schemas = {
							-- Kubernetes schemas - make them more specific
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/deployment.json"] = {
								"deployment.yaml",
								"deployment.yml",
								"*/deployment.yaml",
								"*/deployment.yml",
							},
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/service.json"] = {
								"service.yaml",
								"service.yml",
								"*/service.yaml",
								"*/service.yml",
							},
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/configmap.json"] = {
								"configmap.yaml",
								"configmap.yml",
								"*/configmap.yaml",
								"*/configmap.yml",
							},
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/pod.json"] = {
								"pod.yaml",
								"pod.yml",
								"*/pod.yaml",
								"*/pod.yml",
							},
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/ingress.json"] = {
								"ingress.yaml",
								"ingress.yml",
								"*/ingress.yaml",
								"*/ingress.yml",
							},
							-- Fallback for other Kubernetes resources
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = {
								"*.k8s.yaml",
								"*.k8s.yml",
								"k8s/*.yaml",
								"kubernetes/*.yaml",
							},
							-- Docker Compose
							["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
								"docker-compose.yaml",
								"docker-compose.yml",
								"compose.yaml",
								"compose.yml",
							},
						},
						validate = true,
						hover = true,
						completion = true,
						format = {
							enable = true,
						},
						-- This helps prevent multiple schema matches
						associate = {
							-- Only associate exact filename matches
							"deployment.yaml",
							"service.yaml",
							"configmap.yaml",
						},
					},
				},
			})
			vim.lsp.config("phpactor", {
				capabilities = caps,
				on_attach = on_attach,
				init_options = {},
				settings = {},
			})
			for _, name in ipairs(servers) do
				vim.lsp.config(name, {
					capabilities = caps,
					on_attach = on_attach,
				})
				vim.lsp.enable(name)
			end

			vim.lsp.config("gopls", {
				capabilities = caps,
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
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
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

					-- -- Tab for Copilot, Ctrl+j/k for CMP navigation when CMP is open
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
						vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
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
	{
		"karb94/neoscroll.nvim",
		keys = {
			{
				"<C-u>",
				function()
					require("neoscroll").scroll(-vim.wo.scroll, { duration = 200, easing = "quadratic" })
				end,
				mode = "n",
				noremap = true,
				silent = true,
				desc = "Scroll Up Half Page (Smooth)",
			},
			{
				"<C-d>",
				function()
					require("neoscroll").scroll(vim.wo.scroll, { duration = 200, easing = "quadratic" })
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
					require("neoscroll").scroll(-vim.wo.scroll, { duration = 200, easing = "quadratic" })
				end,
				mode = "v",
				noremap = true,
				silent = true,
				desc = "Scroll Up Half Page (Smooth)",
			},
			{
				"<C-d>",
				function()
					require("neoscroll").scroll(vim.wo.scroll, { duration = 200, easing = "quadratic" })
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
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"css",
					"diff",
					"go",
					"html",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"python",
					"php",
					"phpdoc",
					"query",
					"regex",
					"scss",
					"typescript",
					"tsx",
					"vim",
					"vimdoc",
					"yaml",
					"vue",
				},
				auto_install = true,
				highlight = { enable = true, additional_vim_regex_highlighting = false },
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
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
				-- Make sure autotag is configured elsewhere or remove if not needed
			})
		end,
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
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		keys = {
			{
				"db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"dc",
				function()
					require("dap").continue()
				end,
				desc = "Debug Continue",
			},
			{
				"di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"du",
				function()
					require("dapui").toggle()
				end,
				desc = "DAP UI",
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
})
vim.treesitter.query.set("markdown", "injections", "")
