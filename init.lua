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
-- vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- LSP configuration
local lsp_zero = require("lsp-zero")

-- Function to attach keymaps for LSP-related actions
local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "x" }, "<F3>", function() vim.lsp.buf.format({ async = true }) end, opts)
  vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  on_attach = lsp_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- -- Manually setup Pyright with lspconfig
-- local lspconfig = require('lspconfig')
-- lspconfig.pyright.setup({
--   on_attach = lsp_attach,  -- Use the on_attach function defined above
--   capabilities = require("cmp_nvim_lsp").default_capabilities(),
-- })


-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- Treesitter
-- require("nvim-treesitter.configs").setup({
-- 	ensure_installed = { "lua", "vim", "vimdoc", "python", "query", "markdown", "markdown_inline" },
-- 	sync_install = false,
-- 	auto_install = true,
-- 	highlight = {
-- 		enable = true,
-- 		additional_vim_regex_highlighting = false,
-- 	},
-- })
--

-- UndoTree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      config = function()
        vim.api.nvim_set_keymap("n", "<C-_>", "gcc", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("x", "<C-_>", "gc", { noremap = true, silent = true })
        vim.opt.clipboard = "unnamedplus"
      end,
    },
    "folke/tokyonight.nvim",
    {"nvim-telescope/telescope.nvim",
      dependencies = "nvim-lua/plenary.nvim"},
    {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function() vim.cmd("colorscheme rose-pine") end,
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        null_ls.setup({
          sources = {
            formatting.black,
          },
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ bufnr = bufnr })
                end,
              })
            end
          end,
        })
      end,
    },
    "theprimeagen/harpoon",
    "mbbill/undotree",
    {
      "numToStr/Comment.nvim",
      opts = {
        mappings = { basic = true, extra = false },
        toggler = { line = "<C-_>", block = "gbc" },
        opleader = { line = "<C-_>", block = "gb" },
      },
    },
  },
  -- install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

