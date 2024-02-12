local plug = vim.fn['plug#']

vim.call('plug#begin')
plug('folke/tokyonight.nvim', { branch = 'main' })

plug('nvim-tree/nvim-tree.lua')
plug('nvim-tree/nvim-web-devicons')

plug('nvim-treesitter/nvim-treesitter')

plug('williamboman/mason.nvim')
plug('williamboman/mason-lspconfig.nvim')
plug('neovim/nvim-lspconfig')

plug('numToStr/Comment.nvim')

-- telescope and dependencies
plug('nvim-lua/plenary.nvim')
plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
plug('nvim-telescope/telescope.nvim')

plug('lewis6991/gitsigns.nvim')

plug('nvim-lualine/lualine.nvim')

plug('lukas-reineke/indent-blankline.nvim')

-- plug('akinsho/bufferline.nvim')

plug('sindrets/diffview.nvim')

-- nvim-cmp
plug('hrsh7th/cmp-nvim-lsp')
plug('hrsh7th/nvim-cmp')
plug('hrsh7th/cmp-vsnip')
plug('hrsh7th/vim-vsnip')

plug('folke/trouble.nvim')

plug('akinsho/toggleterm.nvim', { ['tag'] = '*' })
vim.call('plug#end')

-- theme
vim.cmd[[colorscheme tokyonight-night]]

-- global settings
vim.opt.termguicolors = true

vim.opt.swapfile = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true

vim.opt.number = true

-- key binds
vim.g.mapleader = ';'

vim.keymap.set('n', '<F1>', '<nop>')
vim.keymap.set('i', '<F1>', '<nop>')
vim.keymap.set('n', '<F4>', ':%bd|e#|bd#<CR>')

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>E', ':NvimTreeFindFile<CR>')

vim.keymap.set('n', '<leader>?', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<F2>', vim.diagnostic.goto_next)

vim.keymap.set('n', '<leader>q', ':cclose<CR>')

vim.keymap.set('n', '<F7>', ':DiffviewOpen ')
vim.keymap.set('n', '<F8>', ':DiffviewClose<CR>')

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-K>', vim.lsp.buf.signature_help, opts)

        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>fo', function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fG', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>f<leader>', builtin.resume, {})

vim.keymap.set('n', '<leader>vs', builtin.git_status, {})
vim.keymap.set('n', '<leader>vc', builtin.git_commits, {})

require("toggleterm").setup()
vim.keymap.set('n', '<leader>t', '<cmd>ToggleTerm<cr>', {})

-- nvim.tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
    view = {
        adaptive_size = true
    }
})

-- treesitter
require('nvim-treesitter.install').update()
require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = { 
        enable = true
    }
})

require("mason").setup()
require("mason-lspconfig").setup()

-- lsp
require('lspconfig').rust_analyzer.setup({})
require('lspconfig').tsserver.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').eslint.setup({})

-- telescope
require('telescope').setup {
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        width = 0.99,
        height = 0.99,
        results_width = 0.5,
        preview_width = 0.5
      },
      vertical = {
        width = 0.99,
        height = 0.99,
        results_height = 0.3,
        preview_height = 0.7
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    }
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}
require('telescope').load_extension('fzf')

-- utilities
require('Comment').setup()
require('gitsigns').setup()
require('lualine').setup()
require('ibl').setup()
-- require('bufferline').setup()

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
    snippet = {
         expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
         end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true })
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    })
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['rust_analyzer'].setup {
  capabilities = capabilities
}
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities
}
require('lspconfig')['gdscript'].setup {
  capabilities = capabilities
}

