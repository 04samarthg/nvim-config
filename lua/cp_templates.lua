local M = {}

M.config = {
    template_dir = vim.fn.expand("~/.config/nvim/cp_templates"),
    telescope_config = {
        layout_config = {
            width = 0.6,  -- Increased width to accommodate preview
            height = 0.6,
            preview_width = 0.5,
        },
    },
}

local function get_template_files()
    -- Get all template files including those in subdirectories
    local files = vim.fn.globpath(M.config.template_dir, "**/*.templ", false, true)
    local templates = {}
    for _, file in ipairs(files) do
        -- Get relative path from template_dir
        local rel_path = vim.fn.fnamemodify(file, ":s?" .. M.config.template_dir .. "/??")
        -- Remove .templ extension
        rel_path = vim.fn.fnamemodify(rel_path, ":r")
        table.insert(templates, {
            name = rel_path,
            full_path = file
        })
    end
    return templates
end

M.insert_template = function(template_path)
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
            local new_line = cursor_line + solve_line + 1
            local last_line = vim.fn.line('$')
            if new_line <= last_line then
                vim.api.nvim_win_set_cursor(0, {new_line, 0})
                vim.cmd('normal! ^')
                print("Template inserted. Cursor moved to 'void solve()'.")
            else
                print("Template inserted. 'void solve()' found but cursor not moved (beyond file end).")
            end
        else
            print("Template inserted: " .. vim.fn.fnamemodify(template_path, ":t:r"))
        end
    else
        print("Template not found: " .. template_path)
    end
end

function M.select_and_insert_template()
    local templates = get_template_files()
    
    if pcall(require, "telescope") then
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local previewers = require("telescope.previewers")

        -- Custom previewer for template files
        local template_previewer = previewers.new_buffer_previewer({
            title = "Template Preview",
            get_buffer_by_name = function(_, entry)
                return entry.full_path
            end,
            define_preview = function(self, entry)
                if vim.fn.filereadable(entry.full_path) == 1 then
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, 
                        vim.fn.readfile(entry.full_path))
                    
                    -- Set filetype for syntax highlighting
                    local ext = vim.fn.fnamemodify(entry.full_path, ":e:r")
                    if ext == "cpp" or ext == "cc" then
                        vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "cpp")
                    elseif ext == "c" then
                        vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "c")
                    end
                end
            end,
        })

        pickers.new(M.config.telescope_config, {
            prompt_title = "CP Templates",
            finder = finders.new_table({
                results = templates,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.name,
                        ordinal = entry.name,
                        full_path = entry.full_path,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            previewer = template_previewer,
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    M.insert_template(selection.full_path)
                end)
                return true
            end,
        }):find()
    else
        vim.ui.select(templates, {
            prompt = "Select a template:",
            format_item = function(item)
                return item.name
            end,
        }, function(choice)
            if choice then
                M.insert_template(choice.full_path)
            end
        end)
    end
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
