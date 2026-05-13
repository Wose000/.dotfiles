return {
	{
		"nvim-mini/mini.hipatterns",
		opts = function(_, opts)
			local hi = require("mini.hipatterns")

			opts.highlighters = opts.highlighters or {}

			opts.highlighters = vim.tbl_extend("keep", opts.highlighters or {}, {
				hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),

				hl_group = {
					pattern = function(buf)
						return vim.api.nvim_buf_get_name(buf):find("lua/" .. M.module)
							and '^%s*%[?"?()[%w%.@]+()"?%]?%s*='
					end,
					group = function(buf, match)
						local group = M.hl_group(match, buf)
						if group then
							if M.cache[group] == nil then
								M.cache[group] = false
								local hl = vim.api.nvim_get_hl(0, { name = group, link = false, create = false })
								if not vim.tbl_isempty(hl) then
									hl.fg = hl.fg or vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg
									M.cache[group] = true
									vim.api.nvim_set_hl(0, group .. "Dev", hl)
								end
							end
							return M.cache[group] and group .. "Dev" or nil
						end
					end,
					extmark_opts = { priority = 2000 },
				},

				hl_color = {
					pattern = {
						"%f[%w]()c%.[%w_%.]+()%f[%W]",
						"%f[%w]()colors%.[%w_%.]+()%f[%W]",
						"%f[%w]()vim%.g%.terminal_color_%d+()%f[%W]",
					},
					group = function(_, match)
						local parts = vim.split(match, ".", { plain = true })
						local color = vim.tbl_get(M.globals, unpack(parts))
						return type(color) == "string"
							and require("mini.hipatterns").compute_hex_color_group(color, "fg")
					end,
					extmark_opts = function(_, _, data)
						return {
							virt_text = { { "⬤ ", data.hl_group } },
							virt_text_pos = "inline",
							priority = 2000,
						}
					end,
				},
			})
		end,
	},
}
