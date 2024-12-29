return {
	"testcase-manager.nvim", -- or any name you prefer
	dir = vim.fn.stdpath("config") .. "/lua/testcase-manager",
	config = function()
		require("testcase-manager").setup({
			keymap = "<leader>tc",
		})
	end,
	ft = "cpp",
}
