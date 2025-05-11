-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.termguicolors = true
vim.g.have_nerd_font = true

require 'config.lazy'
require 'config.options'
require 'config.keymaps'

-- vim: ts=2 sts=2 sw=2 et
