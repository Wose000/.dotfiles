return {
  'christoomey/vim-tmux-navigator',
  vim.keymap.set('n', 'C-h', ':TmuxNavigateLeft<CR>', { desc = 'Nav Left Pane' }),
  vim.keymap.set('n', 'C-j', ':TmuxNavigateDown<CR>', { desc = 'Nav Down Pane' }),
  vim.keymap.set('n', 'C-k', ':TmuxNavigateUp<CR>', { desc = 'Nav Up Pane' }),
  vim.keymap.set('n', 'C-l', ':TmuxNavigateRight<CR>', { desc = 'Nav Right Pane' }),
}
