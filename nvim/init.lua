vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
--vim.opt.cmdheight = 0
--vim.opt.shortmess:append("W")

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>o', function()
	vim.cmd("update")
	vim.cmd("source %")
end)
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
--vim.keymap.set('n', '<leader>pv', '<cmd>Ex<CR>')
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>P', '"+P<CR>')

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/echasnovski/mini.extra" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
})

-- Auto complete, creates an auto complete and tells omnicomplete about neovim lsp completion
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

require "mason".setup()
require("mini.pick").setup({
	options = {
		use_cache = true,
	}
})

require("mini.extra").setup()

vim.notify = require("notify")

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	float = {
		max_width = 80,
		max_height = 20,
	},
	keymaps = {
		["<CR>"] = "actions.select",
		["-"] = "actions.parent",
		["q"] = "actions.close",
	},
})

require("smear_cursor").setup({
	stiffness = 0.8,
	trailing_stiffness = 0.5,
	distance_stop_animating = 0.5,
	hide_target_hack = false,
	smear_between_buffers = true,
})

require("toggleterm").setup({
  direction = "horizontal",
  size = 12,
  open_mapping = [[<c-\>]],
  persist_size = true,
  shade_terminals = true,
})


require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'ayu_mirage',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				'WinEnter',
				'BufEnter',
				'BufWritePost',
				'SessionLoadPost',
				'FileChangedShellPost',
				'VimResized',
				'Filetype',
				'CursorMoved',
				'CursorMovedI',
				'ModeChanged',
			},
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		--lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_x = { 'encoding', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

-- require "nvim-treesitter.configs".setup({
-- 	ensure_installed = { "lua_ls", "rust-analyzer", "clan
-- })

vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")

vim.lsp.enable({ "lua_ls", "rust_analyzer", "clangd", "jdtls" })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	}
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)


        if client and client:supports_method("textDocument/semanticTokens") then
            vim.lsp.semantic_tokens.enable(true, {
                bufnr = args.buf,
            })
        end
    end,
})


vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

local signs = {
	Error = "✘",
	Warn = "▲",
	Hint = "⚑",
	Info = "»",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Diagnostic navigation
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump({ count = -1 })
end)

vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump({ count = 1 })
end)

-- Show diagnostic under cursor
vim.keymap.set('n', '<leader>vd', function()
	vim.diagnostic.open_float(nil, { focus = false })
end)

-- Show all diagnostics in location list
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist)

vim.keymap.set('n', '<leader>bd', ':bd<CR>')
vim.keymap.set('n', '<leader>bn', ':bn<CR>')
vim.keymap.set('n', '<leader>bp', ':bp<CR>')

vim.keymap.set('n', '<leader>dd', vim.diagnostic.setqflist)
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist)

-- This needs fixing later (Diagnostics in mini.pick)
vim.keymap.set('n', '<leader>fd', function()
	require("mini.extra").pickers.diagnostic()
end)
