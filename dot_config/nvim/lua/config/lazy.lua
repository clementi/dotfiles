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
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- { 'mason-org/mason.nvim',
    --   opts = {}
    -- },
    { 'airblade/vim-gitgutter' },
    { 'editorconfig/editorconfig-vim' },
    { 'jiangmiao/auto-pairs' },
    { 'tpope/vim-surround' },
    { 'factor/factor.vim' },
    { 'ibhagwan/fzf-lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      opts = {},
    },
    { 'nvim-lualine/lualine.nvim',
      dependencies = { 
        'nvim-tree/nvim-web-devicons'
      },
      config = function()
        require('lualine').setup({
          theme = 'auto'
        })
      end
    },
    {
      'serhez/bento.nvim',
      opts = {},
    },
    {
      'shadyalfred/electric-quotes.nvim',
      dependencies = { 'uga-rosa/utf8.nvim' },
      cmd = 'ElectricQuotesToggle',
    },
    {
      'arborist-ts/arborist.nvim',
      config = function()
        require('arborist').setup()
      end
    },
    {
      'folke/ts-comments.nvim',
      opts = {},
      event = 'VeryLazy',
      enabled = vim.fn.has('nvim-0.10.0') == 1,
    },
    { 'romgrk/barbar.nvim' },
    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v3.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      lazy = false,
      config = function ()
        require('neo-tree').setup({
          close_if_last_window = true
        })
      end,
    },
    { 'leafgarland/typescript-vim' },
    {
      'neovim/nvim-lspconfig'
    },
    {
      'voidikss/vim-floaterm'
    },
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      -- dependencies = { 'rafamadriz/friendly-snippets' },
      version = '1.*',
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'super-tab' },

        appearance = {
          nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
      },
    },
    { 'nkxxll/ghostty-default-style-dark.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        require('ghostty-default-style-dark').setup()
        vim.cmd.colorscheme 'ghostty-default-style-dark'
      end
    },
    {
      'scalameta/nvim-metals',
      ft = { 'scala', 'sbt', 'java' },
      opts = function ()
        local metals_config = require('metals').bare_config()
        -- metals_config.on_attach = function (client, bufnr)
        --
        -- end
        return metals_config
      end,
      config = function (self, metals_config)
        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = self.ft,
          callback = function ()
            require('metals').initialize_or_attach(metals_config)
          end,
          group = nvim_metals_group
        })
      end
    },
    { 'neovimhaskell/haskell-vim' },
    {
      'mrcjkb/haskell-tools.nvim',
      version = '^10',
      lazy = false,
    },
    { 'pangloss/vim-javascript' },
    { 'stefanos82/nelua.vim' },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "hybrid" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')
vim.lsp.enable('vtsls')

-- Toggle Neotree
vim.api.nvim_set_keymap(
  'n',
  '<leader>e',
  [[:Neotree<CR>]],
  { noremap = true, silent = true }
)

-- Refresh filetype detection
vim.api.nvim_set_keymap(
  'n',
  '<F10>',
  [[:filetype detect<CR>]],
  { noremap = true, silent = true }
)

-- Open URL under cursor with gx
vim.api.nvim_set_keymap(
  'n',
  'gx',
  [[:lua _G.open_url_under_cursor()<CR>]],
  { noremap = true, silent = true }
)

-- Function to open URL under cursor
function _G.open_url_under_cursor()
  -- Get the current word under cursor
  local word = vim.fn.expand('<cWORD>')

  -- Attempt to extract URL inside parentheses, brackets, or quotes
  local url = word:match("https?://[%w-_%.%?%.:/%+=&]+")

  if url then
    local open_cmd
    if vim.fn.has('mac') == 1 then
      open_cmd = 'open'
    elseif vim.fn.has('unix') == 1 then
      open_cmd = 'xdg-open'
    else
      print('Unsupported OS')
      return
    end
    vim.fn.jobstart({open_cmd, url}, {detach = true})
  else
    print('No valid URL under cursor')
  end
end

