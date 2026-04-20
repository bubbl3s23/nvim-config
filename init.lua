local vim = vim --lsp warnings
local o = vim.opt
-- :help option-list
-- :help vim.opt
o.shiftwidth = 4
o.tabstop = 4
o.expandtab = true
o.number = true
o.relativenumber = false
o.wrap = false
o.list = true
o.signcolumn = "yes"
o.pumheight = 15
o.laststatus = 0
o.mouse = 'a'
o.showmode = false
o.winborder = 'rounded'
o.termguicolors = true
o.updatetime = 250
o.timeoutlen = 300
o.swapfile = false
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.wildmode = { "lastused", "full" }
o.completeopt = { "menuone", "noselect", "popup" }
o.splitright = true
o.splitbelow = true
o.scrolloff = 10
o.cursorline = true
o.confirm = true
o.foldmethod = 'indent'
o.foldlevelstart = 99

local g = vim.g
g.mapleader = ' '
g.maplocalleader = ' '

-- Schedule to improve startup time
vim.schedule(function()
    o.clipboard = 'unnamedplus'
end)

local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights on search' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- split navigation
map('n', '<C-h>', '<C-w><C-h>')
map('n', '<C-l>', '<C-w><C-l>')
map('n', '<C-j>', '<C-w><C-j>')
map('n', '<C-k>', '<C-w><C-k>')

map('n', '<leader>w', ':write<CR>', { silent = true })
map('n', '<leader>o', ':source<CR>', { silent = true })
map('n', '<leader>lf', vim.lsp.buf.format)

-- toggle lsp loclist
map('n', '<leader>q', function()
    local loclist_win = vim.fn.getloclist(0, { winid = 0 }).winid
    if loclist_win > 0 then
        vim.cmd("lclose")
    else
        vim.diagnostic.setloclist({ open = true })
    end
end)

-- copy relative filepath to clipboard
map("n", "<leader>y", function()
    vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy Relative Path" })

local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

autocmd("BufEnter", {
    desc = 'Disable newline comment continuation',
    callback = function()
        o.formatoptions = vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

vim.pack.add({
    "https://github.com/vague2k/vague.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/karb94/neoscroll.nvim",
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-mini/mini.pairs",
    "https://github.com/stevearc/oil.nvim",
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/neovim/nvim-lspconfig'
})

vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

require('neoscroll').setup({ duration = 100, easing = 'sine' })
require("which-key").setup()
require("mini.pick").setup()
require("oil").setup({
    view_options = {
        show_hidden = true,
    }
})
require('gitsigns').setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    }
})

map('n', '<leader>.', '<cmd>Oil<cr>')
map('n', '<leader>s.', "<cmd>Pick files tool='git'<cr>")
map('n', '<leader>sg', '<cmd>Pick grep_live<cr>')

local function setup_lsp()
    vim.lsp.enable({
        "lua_ls",
        "gopls",
        "pyright",
        "tsgo"
    })

    autocmd("LspAttach", {
        callback = function(ev)
            local bufopts = { noremap = true, silent = true, buffer = ev.buf }
            map("n", "grd", vim.lsp.buf.definition, bufopts)
            map("i", "<C-k>", vim.lsp.completion.get, bufopts)
            local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
            local methods = vim.lsp.protocol.Methods
            if client:supports_method(methods.textDocument_completion) then
                vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            end
        end,
    })
end

setup_lsp()
