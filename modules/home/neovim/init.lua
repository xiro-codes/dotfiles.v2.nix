HOME = os.getenv("HOME")
-- Number gutter
vim.opt.number = true
vim.opt.relativenumber = true
-- splits that make since
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Smaller tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
-- Indenting
vim.opt.smartindent = true
vim.opt.autoindent = true
-- Spell Options
vim.opt.spellsuggest = "best,9"
vim.opt.spelloptions = "camel"
-- Undo
vim.opt.undofile = true
vim.opt.undodir = HOME .. "/.config/nvim/undo"
-- Wrap
vim.opt.wrap = false
-- Colors
vim.opt.background = "dark"
vim.cmd([[colorscheme gruvbox]])
vim.cmd([[syntax enable]])
vim.cmd([[filetype plugin indent on]])

vim.g.lightline = {colorscheme = 'gruvbox'}

--require("rust-tools").setup({})
--require("nvim-surround").setup({})
--require("flutter-tools").setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspc= require("lspconfig")
local luasnip = require('luasnip')
local cmp = require('cmp')
lspc.nil_ls.setup({
	capabilities = capabilities
})
lspc.rnix.setup({
	capabilities = capabilities
})
--lspc.rust_analyzer.setup({
--	capabilities = capabilities
--})
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)	
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
		['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<C-P>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<C-S-P>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = {
		{name = "nvim_lsp"},
		{name = "luasnip"},
	},
})

function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, {
		noremap = true, silent = true
	})
end

function nmap(shortcut, command)
	map('n', shortcut, command)
end

function imap(shortcut, command)
	map('i', shortcut, command)
end

nmap("o", "o<Esc>")
nmap("O", "O<Esc>")

nmap("<C-H>", "<C-W><C-H>")
nmap("<C-J>", "<C-W><C-J>")
nmap("<C-K>", "<C-W><C-K>")
nmap("<C-L>", "<C-W><C-L>")

nmap("<C-S-H>", "<C-W><C-S-H>")
nmap("<C-S-J>", "<C-W><C-S-J>")
nmap("<C-S-K>", "<C-W><C-S-K>")
nmap("<C-S-L>", "<C-W><C-S-L>")

