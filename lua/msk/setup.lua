local msk = require 'msk.utils'
local section = msk.section

section('plugins', function(section) 
	require 'msk.plugins'

	section('recompile', function(section)
		local augroup = vim.api.nvim_create_augroup('recompile-plugins', {
			clear = true,
		})

		vim.api.nvim_create_autocmd('BufWritePost', {
			pattern = 'plugins.lua',
			callback = require('packer').compile,
			group = augroup,
		})
	end)

	section('disable-zig-vim', function(section)
		-- zig.vim comes with a bunch of intrusive defaults, so I disable it
		local augroup = vim.api.nvim_create_augroup('disable-zig-vim', {
			clear = true,
		})
		vim.api.nvim_create_autocmd('BufReadPost', {
			pattern = '*.zig',
			group = augroup,
			callback = function()
				vim.b.did_ftplugin = 1
			end
		})
	end)
end)

section('settings', function(section)
	local settings = {
		o = {
			showmode = false,
			hidden = true,
			hlsearch = false,
			tabstop = 4,
			shiftwidth = 4,
			wrap = false,
			cinoptions='(1s',
			termguicolors = true,
			signcolumn = 'yes',
			background = 'dark',
		},
		bo = {
			tabstop = 4,
			shiftwidth = 4,
			cinoptions='(1s',
		},
		wo = {
			number = true,
			cursorline = true,
			wrap = false,
		},
	}
	
	-- Apply settings checking for errors at every propperty
	for locality, opts in pairs(settings) do
		for opt, val in pairs(opts) do
			msk.section('vim.'..locality..'.'..opt, function()
				vim[locality][opt] = val
			end)
		end
	end
end)

section('cmd-abbrevs', function(section)
	msk.cabbrev {'git', 'Git'}

	msk.cabbrev {'WQ', 'wq'}
	msk.cabbrev {'Wq', 'wq'}
	msk.cabbrev {'wQ', 'wq'}
	msk.cabbrev {'qw', 'wq'}
	msk.cabbrev {'Qw', 'wq'}
	msk.cabbrev {'qW', 'wq'}
	msk.cabbrev {'QW', 'wq'}
end)

section('colorscheme', function(section)
	vim.cmd.colorscheme 'catppuccin-frappe'
end)

section('keymaps', function(section)
	vim.g.mapleader = ' '

	section('navigation', function(section)
		vim.keymap.set('n', '<leader>h', '<C-w>h')
		vim.keymap.set('n', '<leader>j', '<C-w>j')
		vim.keymap.set('n', '<leader>k', '<C-w>k')
		vim.keymap.set('n', '<leader>l', '<C-w>l')

		vim.keymap.set('n', '<leader>K', '<cmd>tabn<cr>')
		vim.keymap.set('n', '<leader>J', '<cmd>tabp<cr>')
	end)

	section('terminal', function(section)
		vim.keymap.set('t', '<esc>', '<C-\\><C-n>')
	end)
end)

section('lsp', function(section)
	local defaults = {
		flags = { debounce_text_changes = 150, },
		on_attach = function(client, buf)
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

	local lspconfigs = {
		rust_analyzer = {},
		clangd = {},
		jdtls = {},
		gopls = {},
		tsserver = {},
		html = {},
		pyright = {},
		templ = {},
		ocamllsp = {},
		zls = {},
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
		}
	}

	section('nvim-cmp', function(section)
		defaults.capabilities = require('cmp_nvim_lsp').default_capabilities()
	end)
	
	section('init', function(section)
		local lsp = require 'lspconfig'
		for server, config in pairs(lspconfigs) do
			section(server, function(section)
				lsp[server].setup(vim.tbl_deep_extend('keep', defaults, config))
			end)
		end
	end)

	section('mason', function(section)
		require("mason").setup()
	end)
end)

section('nvim-cmp', function(section)
	vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

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
end)

section('nerdtree', function(section)
	section('set-ignore', function(section)
		vim.cmd "let NERDTreeIgnore=['__pycache__', '\\.pyc$', '\\.o$', '\\.out$', '\\.a$']"
	end)

	section('keymaps', function(section)
		vim.keymap.set('n', '<leader>t', '<cmd>NERDTreeToggle<cr>')
	end)
end)

section('gitgutter', function(section)
	section('disable-old-keymaps', function(section)
		vim.keymap.set('n', '<leader>_a', '<Plug>(GitGutterStageHunk)')
		vim.keymap.set('n', '<leader>_b', '<Plug>(GitGutterUndoHunk)')
		vim.keymap.set('n', '<leader>_c', '<Plug>(GitGutterPreviewHunk)')
	end)

	section('enable-new-keymaps', function(section)
		vim.keymap.set('n', '<leader>gs', '<cmd>GitGutterStageHunk<cr>')
		vim.keymap.set('n', '<leader>gu', '<cmd>GitGutterUndoHunk<cr>')
		vim.keymap.set('n', '<leader>gp', '<cmd>GitGutterPreviewHunk<cr>')
		vim.keymap.set('n', '<leader>gn', '<cmd>GitGutterNextHunk<cr>')
		vim.keymap.set('n', '<leader>gN', '<cmd>GitGutterPrevHunk<cr>')
	end)
end)

section('terminal', function(section)
	require('toggleterm').setup{
		size=15,
		direction='horizontal',
	
		open_mapping=[[<leader>o]],
		terminal_mappings=false,
		insert_mappings=false,
		start_in_insert=false,
		shade_terminals=false,
		winbar = {
			enabled = true,
		}
	}
		
	section('keymaps', function(section)
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
				local message = "There are "..n.." open terminals, please close them before quitting"
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
	end)
end)

section('auto-save', function(section)
	require('auto-save').setup{
		debounce_delay = 5000,
		execution_message = {
			message = function() return "" end,
		}
	}
end)

section('nvim-surround', function(section)
	require('nvim-surround').setup()
end)

section('telescope', function(section)
	require('telescope').setup{
		defaults={
			file_ignore_patterns= {'^package%-lock%.json'}
		}
	}

	section('keymaps', function(section)
		local builtin = require('telescope.builtin')

		vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
		vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
	end)
end)

section('todo-comments', function(section)
	require('todo-comments').setup{}
end)

section('treesitter', function(section)
	section('custom-parsers', function(section)
		local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

		section('my-svelte', function(section)
			-- Uses my version of parser
			parser_config.svelte = {
				install_info = {
					url = "https://github.com/eduardomosko/tree-sitter-svelte",
					branch = "fix-empty-await-then",
					files = { "src/parser.c", "src/scanner.c" },
					revision = 'df1d7e626c7f888fdeb43ba4820ea8ddb69bb1e0',
				},
			}
		end)

		section('go-templ', function(section)
			parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = {"src/parser.c", "src/scanner.c"},
					branch = "master",
				},
			}

			vim.treesitter.language.register('templ', 'templ')
		end)
	end)


	require('nvim-treesitter.configs').setup{
		ensure_installed = {
			'c',
			'javascript',
			'typescript',
			'svelte',
			'bash',
			'python',
			'yaml',
			'json',
			'go',
			'templ',
			'lua',
			'cpp',
			'css',
			'html',
			'ocaml',
			'zig',
		},
		highlight = { enable = true }
	}
end)

