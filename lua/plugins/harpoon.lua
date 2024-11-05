return{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		config = function()
			local ui = require("harpoon.ui")
			local mark = require("harpoon.mark")

			local navigate = function(id)
				return function()
					ui.nav_file(id)
				end
			end

			vim.keymap.set("n", "mm", ui.toggle_quick_menu, { desc = "Open Harpoon" })
			vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "[A]dd file to Harpoon" })
			vim.keymap.set("n", "<leader>1", navigate(1), { desc = "Harpoon Buffer (1)" })
			vim.keymap.set("n", "<leader>2", navigate(2), { desc = "Harpoon Buffer (2)" })
			vim.keymap.set("n", "<leader>3", navigate(3), { desc = "Harpoon Buffer (3)" })
			vim.keymap.set("n", "<leader>4", navigate(4), { desc = "Harpoon Buffer (4)" })
			vim.keymap.set("n", "<leader>5", navigate(5), { desc = "Harpoon Buffer (5)" })
		end,
	}
