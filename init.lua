-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Maps caps-lock to escape while nvim is open
if vim.fn.has("unix") == 1 then
	vim.cmd("silent! !setxkbmap -option caps:escape")
	vim.api.nvim_create_autocmd("VimLeave", {
		command = "silent! !setxkbmap -option",
	})
end
-- Key Binds
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<C-t>", function()
	ui.nav_file(2)
end)
vim.keymap.set("n", "<C-n>", function()
	ui.nav_file(3)
end)
vim.keymap.set("n", "<C-s>", function()
	ui.nav_file(4)
end)

-- LSP
local lsp_zero = require("lsp-zero")

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
	local opts = { buffer = bufnr }

	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
	vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
	vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

lsp_zero.extend_lspconfig({
	sign_text = true,
	lsp_attach = lsp_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "C-p", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- Treesitter
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "lua", "vim", "vimdoc", "python", "query", "markdown", "markdown_inline" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

-- UndoTree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Comment
-- Comment.nvim setup
-- require('Comment').setup()
-- Key mappings for toggling comments
-- vim.api.nvim_set_keymap('n', '<C-//>', 'gcc', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<C-//>', 'gc', { noremap = true, silent = true })

-- Misc settings
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		--{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		--{ import = "lazyvim.plugins.extras.formatting.black" },
		--{ import = "plugins" },
		-- Telescope
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		-- Rose-pine colorscheme
		{
			"rose-pine/neovim",
			name = "rose-pine",
			config = function()
				vim.cmd("colorscheme rose-pine")
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
		},
		"nvim-treesitter/playground",

		-- Other plugins
		"theprimeagen/harpoon",
		"mbbill/undotree",
		"tpope/vim-fugitive",
        {
            'numToStr/Comment.nvim',
            opts = {
                -- Comment.nvim setup options
                mappings = {
                    -- Basic mappings that can be enabled/disabled individually
                    basic = true,
                    extra = false,
                },
                -- Set key mappings here
                -- Ensure the keybinding matches the system's interpretation of <C-_>
                toggler = {
                    line = '<C-_>',  -- Toggle comment for a line in normal mode
                    block = 'gbc',   -- Toggle comment for a block in normal mode (optional)
                },
                opleader = {
                    line = '<C-_>',  -- Toggle comment for lines in visual mode
                    block = 'gb',    -- Toggle comment for a block in visual mode (optional)
                },
            }
        },

		-- LSP and Autocompletion
		{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
		{ "neovim/nvim-lspconfig" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/nvim-cmp" },
	}, -- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
