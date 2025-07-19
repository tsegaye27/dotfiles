vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
			vim.cmd.colorscheme("catppuccin")
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
		-- "ray-x/go.nvim",
		-- dependencies = {
		-- 	"ray-x/guihua.lua",
		-- 	"neovim/nvim-lspconfig",
		-- 	"nvim-treesitter/nvim-treesitter",
		-- },
		-- opts = {
		-- 	gofmt = "gofumpt",
		-- },
		-- config = function(lp, opts)
		-- 	require("go").setup(opts)
		-- 	local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
		-- 	vim.api.nvim_create_autocmd("BufWritePre", {
		-- 		pattern = "*.go",
		-- 		callback = function()
		-- 			require("go.format").gofmt()
		-- 		end,
		-- 		group = format_sync_grp,
		-- 	})
		-- end,
		-- event = { "CmdlineEnter" },
		-- ft = { "go", "gomod" },
		-- build = ':lua require("go.install").update_all_sync()',
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
								symlink_open = "",
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

	{ "wakatime/vim-wakatime", event = "VeryLazy" },
	{ "github/copilot.vim", event = "VeryLazy" },

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

	-- mason.nvim
	{
		"williamboman/mason.nvim",
		cmd = "Mason",

		opts = { ensure_installed = { "prettier", "stylua", "eslint", "eslint_d", "pyright", "gopls" } },

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

			local lspconfig = require("lspconfig")
			local base_caps = vim.lsp.protocol.make_client_capabilities()
			local caps = vim.tbl_deep_extend("force", base_caps, require("cmp_nvim_lsp").default_capabilities())

			local on_attach = function(client, bufnr)
				-- disable formatting on servers you format elsewhere
				if client.name == "ts_ls" or client.name == "pyright" or client.name == "volar" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

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
				"volar",
				"emmet_ls",
			}

			for _, name in ipairs(servers) do
				lspconfig[name].setup({
					capabilities = caps,
					on_attach = on_attach,
				})
			end

			lspconfig.gopls.setup({
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
					["<CR>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.abort(),
					["<S-Tab>"] = cmp.mapping.abort(),
					-- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					-- ["<Tab>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_next_item()
					-- 	elseif luasnip.expand_or_jumpable() then
					-- 		luasnip.expand_or_jump()
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
					-- ["<S-Tab>"] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() then
					-- 		cmp.select_prev_item()
					-- 	elseif luasnip.jumpable(-1) then
					-- 		luasnip.jump(-1)
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { "i", "s" }),
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
					"html",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"python",
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
})
