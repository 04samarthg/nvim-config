-- File: ~/.config/nvim/lua/cp_templates.lua

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

M.insert_template = function(template)
    local template_path = vim.fn.expand(M.config.template_dir .. '/' .. template .. '.templ')
    if vim.fn.filereadable(template_path) == 1 then
        local lines = vim.fn.readfile(template_path)
        local cursor_line = vim.fn.line('.')
        
        vim.api.nvim_put(lines, "l", true, false)
        
        -- Find the line number of "void solve()" function
        local solve_line = 0
        for i, line in ipairs(lines) do
            if line:match("void%s+solve%s*%(%) *{?") then
                solve_line = i
                break
            end
        end
        
        -- If "void solve()" is found, move the cursor to the line below it
        if solve_line > 0 then
            local new_line = cursor_line + solve_line + 1 -- +1 to move to the next line
            local last_line = vim.fn.line('$')
            if new_line <= last_line then
                vim.api.nvim_win_set_cursor(0, {new_line, 0})
                vim.cmd('normal! ^') -- Move to the first non-blank character of the line
                print("Template inserted. Cursor moved to 'void solve()'.")
            else
                print("Template inserted. 'void solve()' found but cursor not moved (beyond file end).")
            end
        else
            print("Template inserted: " .. template)
        end
    else
        print("Template not found: " .. template)
    end
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
                        M.insert_template(selection[1])
                    end)
                    return true
                end,
            })
            :find()
    else
        vim.ui.select(templates, select_opts, function(choice)
            if choice then
                M.insert_template(choice)
            end
        end)
    end
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
