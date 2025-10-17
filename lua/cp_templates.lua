local M = {}

M.config = {
    template_dir = vim.fn.expand("~/.config/nvim/cp_templates"),
}

local function get_template_files()
    local files = vim.fn.globpath(M.config.template_dir, "**/*.templ", false, true)
    local templates = {}
    for _, file in ipairs(files) do
        local rel_path = vim.fn.fnamemodify(file, ":s?" .. M.config.template_dir .. "/??")
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

        local solve_line = 0
        for i, line in ipairs(lines) do
            if line:match("void%s+solve%s*%(%) *{?") then
                solve_line = i
                break
            end
        end

        if solve_line > 0 then
            local new_line = cursor_line + solve_line + 1
            local last_line = vim.fn.line('$')
            if new_line <= last_line then
                vim.api.nvim_win_set_cursor(0, { new_line, 0 })
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

    if pcall(require, "snacks") then
        -- Convert templates to picker items
        local items = {}
        for _, template in ipairs(templates) do
            table.insert(items, {
                text = template.name,
                file = template.full_path,
                template_path = template.full_path,
            })
        end

        Snacks.picker.pick({
            prompt = "CP Templates",
            title = "CP Templates",
            items = items,
            format = function(item)
                return { { item.text } }
            end,
            preview = "file",
            layout = {
                preset = "vertical",
                width = 0.6,
                height = 0.6,
            },
            actions = {
                confirm = function(picker, item)
                    picker:close()
                    M.insert_template(item.template_path)
                end,
            },
        })
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
