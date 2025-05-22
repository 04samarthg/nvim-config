return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		-- disable until lualine loads
		vim.opt.laststatus = 0
	end,
	opts = function()
		-- Catppuccin Mocha colors
		local colors = {
			bg = "#1e1e2e",
			black = "#121220",
			red = "#f38ba8",
			green = "#a6e3a1",
			yellow = "#f9e2af",
			blue = "#89b4fa",
			magenta = "#dd7733",
			cyan = "#94e2d5",
			white = "#ffffff",
			orange = "#fab387",
			grey = "#6c7086",
		}

		-- Conditions
		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width_first = function()
				return vim.fn.winwidth(0) > 80
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 70
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Mode colors
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[""] = colors.orange,
			ic = colors.yellow,
			R = colors.magenta,
			Rv = colors.magenta,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}

		-- Lualine config
		local config = {
			options = {
                globalstatus = true,
				section_separators = "",
				component_separators = "",
				theme = {
					normal = { c = { fg = colors.black, bg = colors.black } },
					inactive = { c = { fg = colors.grey, bg = colors.bg } },
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- Utility functions to add components
		local function active_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		local function active_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		-- Other components (Filename, Branch, etc.)
		active_left({
			function()
				local icon
				local ok, devicons = pcall(require, "nvim-web-devicons")
				if ok then
					icon = devicons.get_icon(vim.fn.expand("%:t"))
					if icon == nil then
						icon = devicons.get_icon_by_filetype(vim.bo.filetype)
					end
				else
					if vim.fn.exists("*WebDevIconsGetFileTypeSymbol") > 0 then
						icon = vim.fn.WebDevIconsGetFileTypeSymbol()
					end
				end
				if icon == nil then
					icon = ""
				end
				return icon:gsub("%s+", "")
			end,
			color = function()
				return { bg = mode_color[vim.fn.mode()], fg = colors.black }
			end,
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
		})

		active_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = function()
				return { bg = mode_color[vim.fn.mode()], fg = colors.black }
			end,
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
			symbols = {
				modified = "󰶻 ",
				readonly = " ",
				unnamed = " ",
				newfile = " ",
			},
		})

		-- Macro recording indicator
		active_left({
			function()
				local recording_register = vim.fn.reg_recording()
				if recording_register ~= "" then
					return "雷 " .. recording_register
				end
				return ""
			end,
			cond = function()
				return vim.fn.reg_recording() ~= ""
			end,
			color = { fg = colors.black, bg = colors.green },
			padding = { left = 1, right = 1 },
			separator = { right = ""},
		})

		active_right({
			"branch",
			icon = "",
			color = { bg = colors.blue, fg = colors.black },
			padding = { left = 0, right = 1 },
			separator = { right = "", left = "" },
		})

		-- Diagnostics
		active_right({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			colored = false,
			color = { bg = colors.magenta, fg = colors.black },
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
		})

		active_right({
			"searchcount",
			color = { bg = colors.cyan, fg = colors.black },
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
		})

		vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#6c7086", bg = "#151520" }) -- Darker border effect

		return config
	end,
}
