vim.opt.rtp:prepend("/home/wose/.dotfiles/src/m/src/neon-colorscheme")
local M = {
	module = "neon-colorscheme",
}

return {
	{
		"nvim-mini/mini.hipatterns",
		opts = function(_, opts)
			local hi = require("mini.hipatterns")

			opts.highlighters = {
				hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
				hl_group = {
					pattern = function(buf)
						return vim.api.nvim_buf_get_name(buf):find("lua/") and '^%s*%[?"?()[%w%.@]+()"?%]?%s*='
					end,
				},
			}
		end,
	},
}
