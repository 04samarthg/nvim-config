-- File: ~/.config/nvim/lua/cp_templates_config.lua

local M = {}

M.config = {
	template_dir = vim.fn.expand("~/.config/nvim/cp_templates"),
	telescope_config = {
		layout_config = {
			width = 0.3,
			height = 0.4,
		},
	},
}

local function get_template_files()
	local files = vim.fn.globpath(M.config.template_dir, "*.templ", false, true)
	local templates = {}
	for _, file in ipairs(files) do
		table.insert(templates, vim.fn.fnamemodify(file, ":t:r"))
	end
	return templates
end

local function insert_template(template_name)
	local template_path = string.format("%s/%s.templ", M.config.template_dir, template_name)
	local content = vim.fn.readfile(vim.fn.expand(template_path))
	vim.api.nvim_put(content, "l", true, true)
end

function M.select_and_insert_template()
	local templates = get_template_files()

	local select_opts = {
		prompt = "Select a template:",
		format_item = function(item)
			return item
		end,
	}

	if pcall(require, "telescope") then
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values

		pickers
			.new(M.config.telescope_config, {
				prompt_title = "CP Templates",
				finder = finders.new_table({
					results = templates,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						insert_template(selection[1])
					end)
					return true
				end,
			})
			:find()
	else
		vim.ui.select(templates, select_opts, function(choice)
			if choice then
				insert_template(choice)
			end
		end)
	end
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
