local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local api = vim.api

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

cmd.filetype 'plugin indent on'

opt.autoindent = true
opt.expandtab = true
opt.linebreak = true
opt.number = true
opt.shiftwidth = 4
opt.shortmess = opt.shortmess + 'I'
opt.tabstop = 4
opt.termguicolors = true
opt.cursorline = true

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    if opts.desc then
      opts.desc = "keymaps.lua: " .. opts.desc
    end
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function remove_trailing_whitespace()
  cmd '%s/\\s\\+$//e'
end

api.nvim_create_autocmd(
  'FileType',
  {
    pattern = {
      'haskell', 'scala', 'c', 'cpp', 'java',
      'python', 'fsharp', 'fstar', 'ocaml', 'sml',
      'csharp', 'json', 'jsonc', 'javascript', 'scheme',
      'racket', 'clojure', 'lisp', 'd', 'rust',
      'go', 'typescript' },
    command = 'autocmd BufWritePre <buffer> lua remove_trailing_whitespace()'
  }
)

map('n', '<F12>', ':set nu!<CR>')
map('n', '<leader>n', ':set nu!<CR>')
map('n', '<F11>', ':set cursorline!<CR>')
map('n', '<leader>l', ':set cursorline!<CR>')
map('n', '<leader>p', ':w!!pf<CR>')
map('n', '<leader>t', ':NvimTreeToggle<CR>')

map('n', '<C-Tab>', ':bn!<CR>')
map('n', '<C-S-Tab>', ':bp!<CR>')
map('n', '<C-j>', ':bp!<CR>')
map('n', '<C-k>', ':bn!<CR>')

map('n', '<Up>', '<Nop>')
map('n', '<Down>', '<Nop>')
map('n', '<Left>', '<Nop>')
map('n', '<Right>', '<Nop>')
-- map('i', '<Up>', '<Nop>')
-- map('i', '<Down>', '<Nop>')
-- map('i', '<Left>', '<Nop>')
-- map('i', '<Right>', '<Nop>')

map('n', '<leader>s', ':lua remove_trailing_whitespace()<CR>', { desc = 'Remove trailing whitespace' })

require('config.lazy')

g.user_emmet_leader_key = '<C-Z>'

if vim.g.neovide then
  local font_size = 11
  if vim.loop.os_uname().sysname == 'Darwin' then
    font_size = 14
  end

  vim.o.guifont = string.format("Ioskeley Mono:h%d", font_size)
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
end
