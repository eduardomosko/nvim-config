local msk = require 'msk.utils'
local section = msk.section

msk.bootstrap_lazy()

section('settings', function(section)
	local settings = {
		g = {
			mapleader = " ",
			loaded_netrw = 1,
			loaded_netrwPlugin = 1,
		},
		o = {
			showmode = false,
			hidden = true,
			hlsearch = false,
			tabstop = 4,
			shiftwidth = 4,
			wrap = false,
			cinoptions = '(1s',
			termguicolors = true,
			signcolumn = 'yes',
			background = 'dark',
		},
		bo = {
			tabstop = 4,
			shiftwidth = 4,
			cinoptions = '(1s',
		},
		wo = {
			number = true,
			cursorline = false,
			wrap = false,
		},
		opt = {
			completeopt = { 'menu', 'menuone', 'noselect' },
		}
	}

	for locality, opts in pairs(settings) do
		section('vim.' .. locality, function(section)
			for opt, val in pairs(opts) do
				section(opt, function()
					vim[locality][opt] = val
				end)
			end
		end)
	end
end)

section('cabbrevs', function(section)
	msk.cabbrev { 'WQ', 'wq' }
	msk.cabbrev { 'Wq', 'wq' }
	msk.cabbrev { 'wQ', 'wq' }
	msk.cabbrev { 'qw', 'wq' }
	msk.cabbrev { 'Qw', 'wq' }
	msk.cabbrev { 'qW', 'wq' }
	msk.cabbrev { 'QW', 'wq' }
end)

section('navigation', function(section)
	vim.keymap.set('n', '<leader>h', '<C-w>h')
	vim.keymap.set('n', '<leader>j', '<C-w>j')
	vim.keymap.set('n', '<leader>k', '<C-w>k')
	vim.keymap.set('n', '<leader>l', '<C-w>l')

	vim.keymap.set('n', '<leader>K', '<cmd>tabn<cr>')
	vim.keymap.set('n', '<leader>J', '<cmd>tabp<cr>')
end)

section('godot', function(section)
	local gdproject = vim.fn.getcwd() .. '/project.godot'
	if (vim.uv or vim.loop).fs_stat(gdproject) then
		vim.fn.serverstart './.godot.pipe'
	end
end)

section('neovide', function(section)
	if vim.g.neovide then
		vim.g.fullscreen = true
		vim.o.guifont = "Ubuntu Mono:h10"

		vim.keymap.set('v', '<c-s-c>', '"+y')   -- Copy
		vim.keymap.set('n', '<c-s-v>', '"+P')   -- Paste normal mode
		vim.keymap.set('v', '<c-s-v>', '"+P')   -- Paste visual mode
		vim.keymap.set('c', '<c-s-v>', '<C-R>+') -- Paste command mode
		vim.keymap.set('i', '<c-s-v>', '<C-R>+') -- Paste insert mode
	end
end)

--[[
section('tree+nnpain', function(section)
	local tree_open = false
	vim.keymap.set('n', '<leader>t', function()
		local api = require('nvim-tree.api')
		local nnpain = require('no-neck-pain.main')
		if tree_open then
			api.tree.close()
			nnpain.enable()
			tree_open = false
		else
			nnpain.disable()
			api.tree.open()
			tree_open = true
		end
	end)
end)
]]

require("lazy").setup({
	spec = {
		-- colorscheme
		{
			'catppuccin/nvim',
			lazy = false,
			priority = 1000, -- Ensure it loads first
			config = function()
				vim.cmd 'colorscheme catppuccin-frappe'
			end,
		},
		{ 'arzg/vim-colors-xcode', lazy = false },
		{ 'shaunsingh/nord.nvim',  lazy = false },
		{ 'rmehri01/onenord.nvim', lazy = false },
		{ 'navarasu/onedark.nvim', lazy = false },
		{ 'folke/tokyonight.nvim', lazy = false },

		-- lsp
		{
			'neovim/nvim-lspconfig',
			dependencies = {
				{
					'williamboman/mason-lspconfig.nvim',
					opts = {},
					dependencies = {
						{ 'williamboman/mason.nvim', opts = {} }
					}
				},
				{ "hrsh7th/cmp-nvim-lsp" }
			},
			config = function()
				local lspconfigs = {
					rust_analyzer = {},
					clangd = {},
					jdtls = {},
					gopls = {},
					ts_ls = {},
					html = {},
					pyright = {},
					templ = {},
					ocamllsp = {},
					gleam = {},
					lua_ls = {
						Lua = {
							workspace = {
								checkThirdParty = false,
								telemetry = { enable = false },
							}
						}
					},
					zls = {},
					ols = {},
					glsl_analyzer = {},
					terraformls = {},
					hls = { filetypes = { 'haskell', 'lhaskell', 'cabal' }, },
					svelte = {
						settings = {
							svelte = {
								plugin = {
									svelte = {
										useNewTransformation = true,
									},
								},
							},
						},
					},
					gdscript = {},
				}


				local lsp = require('lspconfig')
				for server, config in pairs(lspconfigs) do
					section('lspconfig/' .. server, function(section)
						local defaults = {
							flags = { debounce_text_changes = 150 },
							capabilities = require('cmp_nvim_lsp').default_capabilities(),
							on_attach = function(client, buf)
								_ = client

								section('keymaps', function(section)
									local function set(km, cmd)
										vim.keymap.set('n', km, cmd, { buffer = buf })
									end

									set('K', vim.lsp.buf.hover)
									set(']d', vim.diagnostic.goto_next)
									set('[d', vim.diagnostic.goto_prev)
									set('<leader>d', vim.lsp.buf.definition)
									set('<leader>T', vim.lsp.buf.type_definition)
									set('<leader>gi', vim.lsp.buf.implementation)
									set('<leader>rn', vim.lsp.buf.rename)
									set('<leader>R', '<cmd>LspRestart<cr>')

									section('format', function(section)
										set('<leader>i', vim.lsp.buf.format)
									end)
								end)
							end,
						}

						lsp[server].setup(vim.tbl_deep_extend('keep', config, defaults))
					end)
				end
			end
		},
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",

			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip',
			},

			config = function()
				local cmp = require('cmp')
				cmp.setup({
					snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = cmp.mapping.preset.insert({
						['<C-b>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						['<C-Space>'] = cmp.mapping.complete(),
						['<C-e>'] = cmp.mapping.abort(),
						['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					}),
					sources = cmp.config.sources({
						{ name = 'nvim_lsp' },
						{ name = 'luasnip' },
					}, {
						{ name = 'buffer' },
					})
				})
			end,
		},

		-- highlighting
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			tag = 'v0.9.2',
			lazy = false,
			config = function()
				require('nvim-treesitter.configs').setup({
					ensure_installed = {
						'bash',
						'c',
						'cpp',
						'css',
						'gleam',
						'go',
						'javascript',
						'json',
						'lua',
						'vimdoc',
						'ocaml',
						'python',
						'svelte',
						'typescript',
						'yaml',
						'zig',
						'terraform',

						'gdscript',
						--'godot_resource',
						--'gdshader',
					},
					highlight = { enable = true },
				})
			end
		},
		{
			"folke/todo-comments.nvim",
			dependencies = "nvim-lua/plenary.nvim",
			opts = {},
		},
		{ 'habamax/vim-godot' },

		-- git
		{
			"tpope/vim-fugitive",
			config = function()
				msk.cabbrev { 'git', 'Git' }
				msk.cabbrev { 'gti', 'Git' }
				msk.cabbrev { 'tig', 'Git' }
				msk.cabbrev { 'tgi', 'Git' }
			end
		},

		{
			"airblade/vim-gitgutter",
			config = function()
				-- disable old keymaps
				vim.keymap.set('n', '<leader>_a', '<Plug>(GitGutterStageHunk)')
				vim.keymap.set('n', '<leader>_b', '<Plug>(GitGutterUndoHunk)')
				vim.keymap.set('n', '<leader>_c', '<Plug>(GitGutterPreviewHunk)')

				-- enable new
				vim.keymap.set('n', '<leader>gs', '<cmd>GitGutterStageHunk<cr>')
				vim.keymap.set('n', '<leader>gu', '<cmd>GitGutterUndoHunk<cr>')
				vim.keymap.set('n', '<leader>gp', '<cmd>GitGutterPreviewHunk<cr>')
				vim.keymap.set('n', '<leader>gn', '<cmd>GitGutterNextHunk<cr>')
				vim.keymap.set('n', '<leader>gN', '<cmd>GitGutterPrevHunk<cr>')
			end
		},

		-- terminal
		{
			'akinsho/toggleterm.nvim',
			config = function()
				local shell = vim.o.shell
				--if vim.fn.executable('tmux') then
				--	shell = 'tmux'
				--end

				require('toggleterm').setup({
					size = 15,
					direction = 'horizontal',

					open_mapping = '<leader>o',
					terminal_mappings = false,
					insert_mappings = false,
					start_in_insert = false,
					shade_terminals = false,
					auto_scroll = false,
					winbar = {
						enabled = true,
					},

					shell = shell,
				})

				vim.keymap.set('t', '<esc>', '<C-\\><C-n>')

				local t = require('toggleterm.terminal')

				local function find_current_term(terms)
					local window = vim.api.nvim_get_current_win()
					for i, term in pairs(terms) do
						if term.window == window then
							return i, term
						end
					end
					return nil
				end

				local function next_term()
					local terms = t.get_all()
					local i, current = find_current_term(terms)
					if current ~= nil then
						local n = (((i - 1) + 1) % #terms) + 1
						print("next:", n)
						terms[n]:toggle()
						current:toggle()
					end
				end

				local function prev_term()
					local terms = t.get_all()
					local i, current = find_current_term(terms)
					if current ~= nil then
						local n = (((i - 1) - 1) % #terms) + 1
						print("prev:", n)
						terms[n]:toggle()
						current:toggle()
					end
				end

				local function quit_if_no_terminals()
					local terms = t.get_all()
					local n = #terms
					if n ~= 0 then
						local message = "There are " .. n .. " open terminals, please close them before quitting"
						if n == 1 then
							message = "There's an open terminal, please close it before quitting"
						end

						for _, term in pairs(terms) do
							term:close()
						end

						terms[1]:open()
						print(message .. "\n\n")
					else
						vim.cmd "qa"
					end
				end

				vim.keymap.set('n', 'L', next_term)
				vim.keymap.set('n', 'H', prev_term)

				-- TODO: add fallback if terminal is not loaded
				vim.keymap.set('n', 'ZA', quit_if_no_terminals)
			end
		},

		-- files
		--[[
		{
			'nvim-tree/nvim-tree.lua',
			lazy = false,
			opts = {
				renderer = {
					icons = {
						show = {
							file = false,
						},
						glyphs = {
							folder = {
								default = "🗀 ",
								open = "🗁 ",
								empty = "🖿 ",
								arrow_closed = "",
								arrow_open = "",

								-- couldnt make these show
								symlink = "SYMLINK",
								symlink_open = "SYMLINK_OPEN",
							}
						}
					},
				},
			},
		},
		]]
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.8',
			dependencies = { 'nvim-lua/plenary.nvim' },
			config = function()
				local builtin = require('telescope.builtin')
				require('telescope').setup({
					defaults = {
						file_ignore_patterns = { '^package%-lock%.json' },
						winblend = 1
					},
					pickers = {
						find_files = {
							-- include hidden files
							find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
						},
					},
				})

				vim.keymap.set('n', '<leader>ff', builtin.find_files)
				vim.keymap.set('n', '<leader>fg', builtin.live_grep)
				vim.keymap.set('n', '<leader>fb', builtin.buffers)
				vim.keymap.set('n', '<leader>fh', builtin.help_tags)

				vim.keymap.set('n', '<leader>fF', function()
					-- find "all" (include from .gitignore, but not .git)
					builtin.find_files({
						find_command = { "rg", "--files", "--hidden", '--no-ignore-vcs', "--glob", "!**/.git/*" },
					})
				end)
			end
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local harpoon = require("harpoon")
				harpoon:setup()

				vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
				vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

				vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
				vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
				vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
				vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)

				-- Toggle previous & next buffers stored within Harpoon list
				vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
				vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
			end
		},

		{ "kylechui/nvim-surround", opts = {}, version = '*' },

		--[[{
			"shortcuts/no-neck-pain.nvim",
			version = '*',
			minSideBufferWidth = 1,
			lazy = false,
			opts = {
				width = 192,
				autocmds = {
					enableOnVimEnter = true,
					enableOnTabEnter = true,
					skipEnteringNoNeckPainBuffer = true,
				},
				integrations = {
					NvimTree = {
						reopen = false,
					},
				},
			},
		},]] --
	},

	install = {
		colorscheme = { "catppuccin-frappe", "delek" }
		--colorscheme = { "catppuccin-latte", "delek" }
	},
	checker = { enabled = false },
	change_detection = { enabled = false, notify = false },

	performance = {
		rtp = {
			disabled_plugins = {
				-- 'zig.vim' maybe?
			}
		},
	},
})
