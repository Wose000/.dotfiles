-- [[ Setting options ]]op
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers defaultopt
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

vim.diagnostic.config {
  virtual_text = true,
}

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set tab width
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.o.termguicolors = true
vim.cmd.colorscheme 'tokyonight'

-- conceallevel see :help conceallevel
-- used by obsidian.nvim
vim.o.conceallevel = 2

-- to make sure filetype and highlighting work correctly after a session is restored.
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- md colors
vim.api.nvim_set_hl(0, '@markup.strong', { bold = true, fg = '#9566ce' })
vim.api.nvim_set_hl(0, '@markup.emphasis', { italic = true, fg = '#7acb7a' })
vim.api.nvim_set_hl(0, '@markup.italic', { italic = true, fg = '#7acb7a' })

-- markdown headings
vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { bold = true, fg = '#00b38a' })
vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', { bold = true, fg = '#8983ff' })

-- vim: ts=2 sts=2 sw=2 et
