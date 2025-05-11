return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
  config = function()
    require('render-markdown').setup {
      completions = { lsp = { enabled = true } },
      checkbox = {
        checked = { scope_highlight = '@markup.strikethrough' },
        custom = {
          important = { raw = '[!]', rendered = ' ', highlight = 'DiagnosticWarn' },
          wait = { raw = '[>]', rendered = '󰥔 ', highlight = 'DiagnosticWarn' },
        },
      },
      latex = {
        enabled = true,
        converter = 'latex2text',
        highlight = 'RenderMarkdownMath',
        top_pad = 0,
        bottom_pad = 0,
      },
      heading = {
        enabled = true,
        render_modes = false,
        atx = true,
        setext = true,
        sign = true,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        position = 'overlay',
        signs = { '󰫎 ' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = '▄',
        below = '▀',
        backgrounds = {
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH4',
          'RenderMarkdownH5',
          'RenderMarkdownH3',
          'RenderMarkdownH1',
          'RenderMarkdownH2',
          'RenderMarkdownH6',
        },
        custom = {},
      },
    }
  end,
}
