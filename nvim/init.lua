vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("settings")
require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ -- Automatically adjust shiftwidth and expandtab
		"tpope/vim-sleuth",
	},

	{ -- Gitsigns: Display Git changes and blame
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})
		end,
	},

	{ -- Emmet: HTML and CSS autocompletion
		"mattn/emmet-vim",
		init = function()
			vim.g.user_emmet_mode = "a" -- Enable Emmet in all modes
			vim.g.user_emmet_leader_key = "<C-y>" -- Set Emmet trigger key
		end,
	},

	{ -- Which-key: Shows available keybindings
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
		},
	},

	{ -- Nvim-tree: File explorer with keybinding
		"nvim-tree/nvim-tree.lua",
		event = "VimEnter",
		config = function()
			require("nvim-tree").setup({
				filters = {
					dotfiles = false, -- Keep this false to show dotfiles, or true to hide all dotfiles
					custom = { "^.git$" }, -- Hide .git folder
				},
				renderer = {
					root_folder_label = false, -- Remove the `~` indicator at the top
					icons = {
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
							},
							git = {
								unstaged = "✗",
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
			})
			vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
		end,
	},

	{ "wakatime/vim-wakatime" },
	{ "github/copilot.vim" },

	{ -- Indentation guides
		"lukas-reineke/indent-blankline.nvim",
		version = "^3.0", -- Ensure you're using version 3
		config = function()
			require("ibl").setup({
				indent = {
					char = "│", -- Character to use for the indent line
					tab_char = "│", -- Character to use for tab indentation
				},
				scope = {
					show_start = false, -- Disable scope start
					show_end = false, -- Disable scope end
				},
				exclude = {
					filetypes = {
						"help",
						"dashboard",
						"neo-tree",
						"Trouble",
						"lazy",
						"mason",
						"toggleterm",
						"lspinfo",
					},
				},
			})
		end,
	},
	{ -- Conform: Format on save using external formatters
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
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 5000,
					lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" }, -- Use stylua for Lua
				javascript = { "prettier" },
				typescript = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" }, -- Use prettier for HTML
			},
		},
	},

	{ -- Auto-close and rename HTML/JSX tags
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	------------------------------------------------------------------------------
	-- 3. Statusline, Debugging, & Miscellaneous Utilities
	------------------------------------------------------------------------------

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					globalstatus = true,
					disabled_filetypes = { "alpha", "dashboard" },
				},
				sections = {
					lualine_a = {
						{
							"mode",
							icon = "",
							separator = { left = "", right = "" },
							color = { fg = "#ffffff", bg = "#006992" },
						},
					},
					lualine_b = {
						{
							"branch",
							icon = "",
							separator = { left = "", right = "" },
							color = { fg = "#ffffff", bg = "#6a0dad" },
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
							separator = { left = "", right = "" },
							color = { fg = "#ffffff", bg = "#4b0082" },
						},
					},
					lualine_c = {
						{
							"filename",
							path = 1,
							file_status = true,
							symbols = { modified = "", readonly = "" },
							color = { fg = "#ffffff", bg = "#1e1e2e" },
						},
					},
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
							separator = { left = "", right = "" },
							color = { fg = "#ffffff", bg = "#1e1e2e" },
						},
						{
							"filetype",
							icon_only = true,
							separator = { left = "", right = "" },
							color = { fg = "#ffffff", bg = "#1e1e2e" },
						},
					},
					lualine_y = {
						{
							"progress",
							separator = { left = "", right = "" },
							color = { fg = "#ffffff", bg = "#1e1e2e" },
						},
					},
					lualine_z = {
						{
							"location",
							separator = { left = "", right = "" },
							color = { fg = "#ffffff", bg = "#006992" },
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},

	{ -- Comment.nvim: Easily comment code
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{ -- nvim-autopairs: Automatically complete pairs
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{ -- Spectre: Search and replace tool
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("spectre").setup()
		end,
	},

	{ -- Telescope: Fuzzy finder and more
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
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
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	------------------------------------------------------------------------------
	-- 4. LSP & Autocompletion Configuration
	------------------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = { ensure_installed = { "prettier", "stylua", "eslint", "eslint_d", "pyright" } },
			},
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("lspconfig").volar.setup({
				filetypes = { "vue", "typescript", "javascript" },
			})
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls", "tailwindcss", "cssls", "lua_ls", "html" }, -- Correct server names
				automatic_installation = true,
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			if vim.g.have_nerd_font then
				local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
				for type, icon in pairs(signs) do
					local hl = "DiagnosticSign" .. type
					vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
				end
			end
			local servers = {
				ts_ls = { -- Correct server name for TypeScript (typescript-language-server)
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						local map = function(keys, func, desc)
							vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
						end
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.code_action({
									context = { only = { "source.fixAll" }, diagnostics = {} },
									apply = true,
								})
							end,
						})
						map("<leader>oi", function()
							vim.lsp.buf.code_action({
								context = { only = { "source.organizeImports" }, diagnostics = {} },
								apply = true,
							})
						end, "[O]rganize [I]mports")
					end,
					capabilities = capabilities,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
							},
							preferences = {
								importModuleSpecifierPreference = "non-relative",
								quotePreference = "single",
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
							},
							preferences = {
								importModuleSpecifierPreference = "non-relative",
								quotePreference = "single",
							},
						},
					},
				},
				tailwindcss = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
					},
				},
				pyright = {
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						local map = function(keys, func, desc)
							vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
						end
						map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
						map("K", vim.lsp.buf.hover, "Hover Documentation")
					end,
				},
				cssls = {},
				lua_ls = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				html = {}, -- HTML LSP for intellisense
			}
			local ensure_installed = vim.tbl_keys(servers)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_installation = true,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
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
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			-- Tailwind CSS completion
			"roobert/tailwindcss-colorizer-cmp.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			-- Setup Tailwind colorizer
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "nvim_lsp", option = { keyword_pattern = [[\k\+]] } }, -- Ensures better Tailwind completion
				}),
				formatting = {
					format = require("tailwindcss-colorizer-cmp").formatter,
				},
			})
		end,
	},

	------------------------------------------------------------------------------
	-- 5. Look & Feel: Colorscheme, Todo Comments, and Mini Plugins
	------------------------------------------------------------------------------
	{ -- Colorscheme: Tokyonight
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},

	{ -- Smooth scrolling
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({})
		end,
	},
	{ -- Treesitter: Syntax highlighting and more
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag", -- Auto-tagging for HTML/JSX
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"css",
					"javascript",
					"typescript",
					"tsx",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
				},
				auto_install = true,
				highlight = { enable = true, additional_vim_regex_highlighting = false },
				indent = { enable = true, disable = { "ruby" } },
				fold = { enable = true }, -- Enable Treesitter-based folding
			})

			require("nvim-ts-autotag").setup()
		end,
	},
})
