local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ";"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.colorcolumn = "100"

require("lazy").setup({
    spec = {
        {
            "folke/tokyonight.nvim",
            lazy = true,
            priority = 1000,
            opts = {}
        },
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                sections = {
                    lualine_c = { { 'filename', path = 1 } }
                },
                tabline = {
                    lualine_a = { {
                        'buffers',
                        mode = 2,
                        section_separators = { left = '', right = '' },
                        component_separators = { left = '', right = '' },
                    } },
                    lualine_z = { {
                        'tabs',
                        section_separators = { left = '', right = '' },
                        component_separators = { left = '', right = '' },
                    } },
                },
            }
        },
        {
            "nvim-telescope/telescope.nvim",
            version = "*",
            dependencies = {
                'nvim-lua/plenary.nvim',
                { 'nvim-telescope/telescope-fzf-native.nvim', build = "make" }
            },
            opts = {
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            prompt_position = "bottom",
                            width = { padding = 0 },
                            height = { padding = 0 },
                            preview_height = 0.7,
                        }
                    }
                },
                pickers = {
                    buffers = {
                        ignore_current_buffer = true,
                        sort_lastused = true,
                    },
                },
            }
        },
        {
            "stevearc/conform.nvim",
            opts = {
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = "fallback"
                },
            }
        },
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
                "nvim-tree/nvim-web-devicons", -- optional, but recommended
            },
            lazy = false,                      -- neo-tree will lazily load itself
            opts = {
                sources = { "filesystem", "buffers", "git_status", "document_symbols" }
            }
        },
        { "lewis6991/gitsigns.nvim" },
        {
            "saghen/blink.cmp",
            version = "*",
            opts = {
                keymap = { preset = 'default' },
                appearance = { nerd_font_variant = 'mono' },
                completion = { documentation = { auto_show = false } },
                sources = { default = { 'lsp', 'path', 'snippets', 'buffer' }, },
                fuzzy = { implementation = "prefer_rust_with_warning" }
            },
            opts_extend = { "sources.default" }
        },
        { "neovim/nvim-lspconfig" },
        {
            "chentoast/marks.nvim",
            event = "VeryLazy",
            opts = {},
        },
        {
            "stevearc/oil.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            lazy = false,
            opts = {
                view_options = {
                    show_hidden = true
                }
            }
        },
        { "sindrets/diffview.nvim" },
        {
            "mason-org/mason.nvim",
            opts = {}
        }
    },
    checker = { enabled = true, notify = false },
})

vim.cmd [[
  colorscheme tokyonight-night
  set expandtab
  set number
  set relativenumber
  set shiftwidth=4
  set tabstop=4
  set softtabstop=4
  set ignorecase
  set smartcase
  set scrolloff=3
]]

vim.lsp.enable("lua_ls")
vim.lsp.enable("zls")

vim.keymap.set("n", "-", "<CMD>Oil<CR>")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fl", builtin.git_status)
vim.keymap.set("n", "<leader>fm", builtin.marks)
vim.keymap.set("n", "<leader>f;", builtin.resume)
vim.keymap.set("n", "<leader>f'", builtin.search_history)

vim.keymap.set("n", "<leader>?", builtin.diagnostics)
vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_next)

vim.keymap.set("n", "grd", vim.lsp.buf.definition)
vim.keymap.set("n", "grD", vim.lsp.buf.declaration)
vim.keymap.set("n", "grc", vim.lsp.buf.incoming_calls)

vim.keymap.set('n', '<leader>q', ':cclose<CR>')

vim.keymap.set("n", "<leader>ee", "<cmd>Neotree position=right toggle<CR>")
vim.keymap.set("n", "<leader>eE", "<cmd>Neotree position=right reveal toggle<CR>")
vim.keymap.set("n", "<leader>eb", "<cmd>Neotree position=right buffers toggle<CR>")
vim.keymap.set("n", "<leader>el", "<cmd>Neotree position=right git_status toggle<CR>")
vim.keymap.set("n", "<leader>eo", "<cmd>Neotree position=right document_symbols toggle<CR>")

vim.keymap.set("n", "g,", "<cmd>bprevious<CR>");
vim.keymap.set("n", "g.", "<cmd>bnext<CR>");
