return {
	"brenoprata10/nvim-highlight-colors",

	config = function()
		require("nvim-highlight-colors").setup({
			---render style
			---@usage 'background'|'foreground'|'virtual'
			render = "background",

			---set virtual symbol (requires render to be set to 'virtual')
			virtual_symbol = "■",

			---set virtual symbol suffix (defaults to '')
			virtual_symbol_prefix = "",

			---set virtual symbol suffix (defaults to ' ')
			virtual_symbol_suffix = " ",

			---set virtual symbol position()
			---@usage 'inline'|'eol'|'eow'
			---inline mimics vs code style
			---eol stands for `end of column` - recommended to set `virtual_symbol_suffix = ''` when used.
			---eow stands for `end of word` - recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
			virtual_symbol_position = "inline",

			---highlight hex colors, e.g. '#ffffff'
			enable_hex = true,

			---highlight short hex colors e.g. '#fff'
			enable_short_hex = true,

			---highlight rgb colors, e.g. 'rgb(0 0 0)'
			enable_rgb = true,

			---highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
			enable_hsl = true,

			---highlight css variables, e.g. 'var(--testing-color)'
			enable_var_usage = true,

			---highlight named colors, e.g. 'green'
			enable_named_colors = true,

			---highlight tailwind colors, e.g. 'bg-blue-500'
			enable_tailwind = false,

			---set custom colors
			---label must be properly escaped with '%' to adhere to `string.gmatch`
			--- :help string.gmatch
			custom_colors = {
				{ label = "%-%-theme%-primary%-color", color = "#0f1219" },
				{ label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
			},

			-- exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
			exclude_filetypes = {},
			exclude_buftypes = {},
		})
	end,
}
