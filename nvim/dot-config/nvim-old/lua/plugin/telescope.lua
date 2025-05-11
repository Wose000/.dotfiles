return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },
  config = function()
    require 'telescope_setup'
  end,
}
