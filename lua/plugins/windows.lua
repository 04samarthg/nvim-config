return {
	{
		"anuvyklack/windows.nvim",
		dependencies = {"anuvyklack/middleclass"},
		requires = "anuvyklack/middleclass",
		event = "BufReadPost",
		config = function()
			require("windows").setup()
		end,
	},
	{
		"nvim-zh/colorful-winsep.nvim",
		config = true,
		event = { "WinLeave" },
	}
}
