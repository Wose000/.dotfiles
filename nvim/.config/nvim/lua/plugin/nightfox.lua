local options = {
  transparent = true,
}
local specs = {
  duskfox = {
    syntax = {
      bracket = 'blue.light',
      builtin0 = 'pink', -- returns
      builtin1 = 'cyan',
      builtin2 = 'red.dim',
      -- commment
      conditional = 'pink',
      const = 'yellow.bright',
      -- dep
      dep = 'black',
      field = 'blue.bright',
      func = 'red',
      ident = 'pink.bright',
      keyword = 'pink.light',
      number = 'yellow.light',
      operator = 'pink.bright',
      preproc = 'magenta.dim',
      -- regex
      statement = 'red.bright',
      string = 'white',
      type = 'black.light',
      variable = 'cyan.light',
    },
  },
}
return {
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      local shade = require 'nightfox.lib.shade'
      -- base bright dim light
      local red = shade.new('#e358ff', '#e766f8', '#c849eb', '#eb78f3')
      local magenta = shade.new('#a347ff', '#b058f7', '#b83ce9', '#bc6af3')
      local green = shade.new('#1fff75', '#3ff57f', '#21d6a0', '#57ef87')
      local cyan = shade.new('#23eae0', '#3fe7dc', '#2871bc', '#57e6dc')
      local purp = shade.new('#8578ff', '#9c89f9', '#9566ee', '#ab96f5')
      local turq = shade.new('#01ffc4', '#25f4c0', '#16c6a6', '#42edc0')
      local lightgreen = shade.new('#9dff82', '#acfa9f', '#84e870', '#b7f7a7')
      local blue = shade.new('#36abff', '#55b0f6', '#3095e8', '#6cb3f1')
      local yellow = shade.new('#f5ff9b', '#f8fba3', '#e1ec83', '#f9f8a9')
      local palettes = {
        duskfox = {
          black = turq,
          red = red,
          green = green,
          yellow = yellow,
          cyan = cyan,
          magenta = magenta,
          blue = blue,
          white = lightgreen,
          pink = purp,
          bg1 = '#0e111d',
          fg0 = '#acfa9f',
        },
      }
      require('nightfox').setup {
        options = options,
        palettes = palettes,
        specs = specs,
      }
    end,
  },
}
