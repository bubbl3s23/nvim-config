-- :help option-list
-- :help vim.opt
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.signcolumn = "yes"
-- vim.opt.pumheight = 15
-- vim.opt.laststatus = 0
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.winborder = "rounded"
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.opt.wildmode = { "lastused", "full" }
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.cursorline = true
vim.opt.confirm = true
vim.opt.shiftwidth = 2

-- vim.opt.foldmethod = 'indent'
-- vim.opt.foldlevelstart = 99
-- completion
-- vim.opt.complete = ".,o"
-- vim.opt.completeopt = { "menuone", "noselect", "popup" }
-- vim.opt.autocomplete = true

local g = vim.g
g.mapleader = " "
g.maplocalleader = " "

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
-- Copy paste through
if vim.env.SSH_CONNECTION then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
    vim.g.clipboard = {
      name = "osc52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }
  end
end

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights on search" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- split navigation
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-l>", "<C-w><C-l>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")

map("n", "<leader>fs", ":write<CR>", { silent = true })
map("n", "<leader>o", ":source<CR>", { silent = true })
map("n", "<leader>lf", vim.lsp.buf.format)
-- copy relative filepath to clipboard
map("n", "<leader>y", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy Relative Path" })

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic " })

local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.hl_op()
  end,
})

-- autocmd("BufEnter", {
--   desc = "Disable newline comment continuation",
--   callback = function()
--     vim.opt.formatoptions = vim.opt.formatoptions:remove({ "c", "r", "o" })
--   end,
-- })

autocmd("FileType", {
  pattern = "*.txt",
  callback = function()
    vim.opt.wrap = true
  end,
})

vim.pack.add({
  -- UI
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",

  "https://github.com/karb94/neoscroll.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  -- Editor
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/folke/todo-comments.nvim",
  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/pmizio/typescript-tools.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  -- autoformat
  "https://github.com/stevearc/conform.nvim",
  -- Neovim dev
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/folke/lazydev.nvim",
  -- Completion
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
  -- Themes
  "https://github.com/vague2k/vague.nvim",
  "https://github.com/uhs-robert/oasis.nvim",
  "https://github.com/mcauley-penney/techbase.nvim",
  "https://github.com/ficcdaf/ashen.nvim",
  "https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/olimorris/onedarkpro.nvim",
  "https://github.com/sainnhe/gruvbox-material",
  "https://github.com/vimcolorschemes/olive-crt.nvim",
})

vim.opt.background = "dark"
-- vim.opt.background = 'light'
vim.cmd("colorscheme vague")
-- vim.cmd("colorscheme kanagawa-dragon")
-- vim.cmd("colorscheme oasis-luna")
-- vim.cmd("colorscheme gruvbox-material")

require("neoscroll").setup({ duration = 100, easing = "sine" })
require("todo-comments").setup()
require("mini.pairs").setup()
require("nvim-web-devicons").setup()
require("which-key").setup({
  delay = 0,
  icons = { mappings = true },
  spec = {
    { "<leader>f", group = "[F]ile", mode = { "n", "v" } },
    { "<leader>fs", group = "[F]ile [S]ave", mode = { "n", "v" } },
    { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
    { "<leader>t", group = "[T]oggle" },
    { "gr", group = "LSP Actions", mode = { "n" } },
  },
})

-- NOTE: stylua defaults to tabs, provisionally fixed outside neovim in global stylua config file
-- ~/.config/stylua/stylua.toml
-- Set preference here later?
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "diff", "diagnostics" },
    lualine_c = { "lsp_status", "filename", "searchcount" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { "fzf" },
})

local fzf_picker = require("fzf-lua")
fzf_picker.setup({ "skim" })

-- TODO: Use registry?
local function pick_cwd()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  local current_dir = vim.fn.fnamemodify(current_file, ":h")
  if current_dir == "" then
    current_dir = "."
  end
  fzf_picker.files({ cwd = current_dir })
end
-- Navigation keymaps
map("n", "<leader>s.", "<cmd>Oil<cr>", { desc = "[S]earch Working dir" })
map("n", "<leader><leader>", fzf_picker.files, { desc = "[S]earch [F]iles" })
map("n", "<leader>.", pick_cwd, { desc = "[S]earch Working dir" })
map("n", "<leader>s<leader>", fzf_picker.history, { desc = "[S]earch Working dir" })
map("n", "<leader>sb", fzf_picker.buffers, { desc = "[S]earch [Buffers]" })
map("n", "<leader>sg", fzf_picker.live_grep_native, { desc = "[S]earch Grep Files" })
map("n", "<leader>s/", fzf_picker.grep_curbuf, { desc = "[S]earch Grep Current buffer" })
map("n", "<leader>sc", fzf_picker.colorschemes, { desc = "[S]earch Colorschemes" })

vim.lsp.enable({
  "lua_ls",
  "gopls",
  "pyright",
  "nixd",
  "sqls",
  -- "emmet_language_server"
})

require("lazydev").setup()

-- TODO: This creates checkhealth warning
-- Send pr typescript-tools?
require("typescript-tools").setup({
  settings = {
    jsx_close_tag = {
      enable = true,
      -- filetypes = { "javascriptreact", "typescriptreact" },
    },
  },
})

-- LSP keymaps
autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local bufopts = { noremap = true, buffer = event.buf }

    map("n", "grn", vim.lsp.buf.rename, bufopts)
    map("n", "gra", vim.lsp.buf.code_action, bufopts)
    map("n", "grd", vim.lsp.buf.definition, bufopts)

    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local methods = vim.lsp.protocol.Methods

    -- if client:supports_method(methods.textDocument_completion) then
    --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    -- end

    -- Highlight references of word under hover
    if client:supports_method(methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("hover-highlight", { clear = false })

      autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("hover-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "hover-highlight", buffer = event2.buf })
        end,
      })
    end

    if client and client:supports_method(methods.textDocument_inlayHint) then
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr = event.buf })
      end, { buffer = event.buf })
    end
  end,
})

local ts_langs = {
  "javascript",
  "typescript",
  "tsx",
  "python",
  "sql",
  "nix",
  "dockerfile",
  "c",
  "bash",
  "html",
  "lua",
  "markdown",
  "xml",
}

require("nvim-treesitter").install(ts_langs)

-- TODO: Expand on this?
-- :h
autocmd("FileType", {
  pattern = ts_langs,
  callback = function()
    vim.treesitter.start()
    -- Folds
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'
    -- Indentatation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- TODO: Remove luasnip?
require("luasnip.loaders.from_vscode").lazy_load()
-- TODO: Expand (window, appearance)
require("blink.cmp").setup({
  -- `:help ins-completion`
  keymap = {
    preset = "default",
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    ghost_text = { enabled = true },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    menu = {
      auto_show = true,
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
  snippets = { preset = "luasnip" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
})
