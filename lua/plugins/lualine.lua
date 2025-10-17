return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		-- disable until lualine loads
		vim.opt.laststatus = 0
	end,
	opts = function()
		local colors = {
			bg = "#2a2a2e", -- background of inactive sections (slightly darker neutral)
			bg_alt = "#3a3a3f", -- alt background
			bg_highlight = "#4a4a50",
			fg = "#000000", -- black text
			grey = "#b0b0b0",
			blue = "#a0c8ff", -- calm sky blue
			green = "#a8ffb0", -- mint green
			cyan = "#a8f7ff", -- icy cyan
			red = "#ff9a9a", -- muted coral
			yellow = "#fff59a", -- soft yellow
			magenta = "#ff9aff", -- rosy magenta
			pink = "#ff9ac9", -- blush pink
			orange = "#ffc78a", -- warm orange
			purple = "#c79aff", -- lilac purple
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
			n      = colors.red,
			i      = colors.green,
			v      = colors.blue,
			[""]   = colors.blue,
			V      = colors.blue,
			c      = colors.magenta,
			no     = colors.red,
			s      = colors.orange,
			S      = colors.orange,
			ic     = colors.yellow,
			R      = colors.magenta,
			Rv     = colors.magenta,
			cv     = colors.red,
			ce     = colors.red,
			r      = colors.cyan,
			rm     = colors.cyan,
			["r?"] = colors.cyan,
			["!"]  = colors.red,
			t      = colors.red,
		}

		-- Lualine config
		local config = {
			options = {
				globalstatus = true,
				section_separators = "",
				component_separators = "",
				theme = {
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.grey, bg = colors.bg } },
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		}

		-- Utility functions to add components
		local function active_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		local function active_right(component)
			table.insert(config.sections.lualine_x, component)
		end

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
				return { bg = mode_color[vim.fn.mode()] or colors.purple, fg = colors.fg }
			end,
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
		})

		-- filename
		active_left({
			"filename",
			cond = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
			color = function() return { bg = mode_color[vim.fn.mode()] or colors.purple, fg = colors.fg } end,
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
			symbols = { modified = "󰶻 ", readonly = " ", unnamed = " ", newfile = " " },
		})

		-- macro recording
		active_left({
			function()
				local reg = vim.fn.reg_recording()
				if reg ~= "" then
					return "󰑊 REC @" .. reg
				end
				return ""
			end,
			cond = function()
				return vim.fn.reg_recording() ~= ""
			end,
			color = function()
				return { bg = colors.red, fg = colors.fg }
			end,
			padding = { left = 1, right = 1 },
			separator = { right = "" },
		})

		-- git branch
		active_right({
			"branch",
			icon = "",
			color = { bg = colors.blue, fg = colors.fg },
			padding = { left = 0, right = 1 },
			separator = { right = "", left = "" },
		})

		active_right({
			function()
				local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
				if next(buf_clients) == nil then
					return "No LSP"
				end
				return "  " .. buf_clients[1].name
			end,
			color = { bg = colors.purple, fg = colors.fg },
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
		})

		-- diagnostics
		active_right({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			colored = false,
			color = { bg = colors.magenta, fg = colors.fg },
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
		})

		-- search count
		active_right({
			"searchcount",
			color = { bg = colors.cyan, fg = colors.fg },
			padding = { left = 1, right = 1 },
			separator = { right = "", left = "" },
		})

		return config
	end,
}
