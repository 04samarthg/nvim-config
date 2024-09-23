local M = {}

-- Store contest ID and problems
M.contest_id = nil
M.problems = {}
M.logged_in = false

-- Configuration options
M.config = {
    telescope_config = {
        width = 0.3,
        height = 0.4,
    },
}

-- Function to parse problems using the Python script
local function parse_problems(contest_id)
    local handle = io.popen('python3 ' .. '~/cp/fetch_probs.py ' .. contest_id)
    local result = handle:read("*a")
    handle:close()
    print("Raw output from Python script:")
    print(result)
    M.problems = {}
    for line in result:gmatch("[^\r\n]+") do
        local id, name = line:match("([^|]+)|(.+)")
        if id and name then
            table.insert(M.problems, {id = id, name = name})
            print("Parsed problem: " .. id .. " - " .. name)
        else
            print("Failed to parse line: " .. line)
        end
    end
    print("Total problems parsed: " .. #M.problems)
end

-- Function to parse input/output using the Python script
local function parse_io(contest_id, problem_id)
    local handle = io.popen('python3 ' .. '~/cp/fetch_ip_op.py ' .. contest_id .. ' ' .. problem_id)
    local result = handle:read("*a")
    handle:close()
end

-- Function to handle login
local function handle_login()
    if M.logged_in then
        return true
    end

    local input = vim.fn.input("Codeforces credentials not found. Do you want to login now? (y/n): ")
    if input:lower() ~= "y" then
        print("Login cancelled. You need to be logged in to submit solutions.")
        return false
    end

    local cmd = 'python3 ~/cp/cfSubmit.py login'
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()

    if result:find("Login successful!") then
        M.logged_in = true
        print("Login successful!")
        return true
    else
        print("Login failed. Please try again.")
        return false
    end
end

-- Function to submit solution using the Python script
local function submit_solution(file_path)
    if not handle_login() then
        return
    end

    local cmd = string.format('python3 ~/cp/script.py %s %s %s', M.contest_id, M.current_problem, file_path)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    print("Submission result:")
    print(result)
end

-- Function to start Codeforces session
function M.start()
    vim.ui.input({prompt = "Enter contest ID: "}, function(input)
        if input then
            M.contest_id = input
            parse_problems(M.contest_id)
            print("Contest " .. M.contest_id .. " loaded")
            -- handle_login()
        end
    end)
end

-- Function to show problem list using Telescope
function M.show()
    if not M.contest_id then
        print("No contest loaded. Use 'cf start' first.")
        return
    end
    if #M.problems == 0 then
        print("No problems found. Make sure the contest ID is correct and the fetch_probs.py script is working.")
        return
    end
    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    
    -- Custom theme for a smaller window
    local custom_theme = require("telescope.themes").get_dropdown({
        width = M.config.telescope_config.width,
        height = M.config.telescope_config.height,
        previewer = false,
    })
    
    pickers.new(custom_theme, {
        prompt_title = "Codeforces Problems",
        finder = finders.new_table {
            results = M.problems,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.id .. ": " .. entry.name,
                    ordinal = entry.id,
                }
            end
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                parse_io(M.contest_id, selection.value.id)
                print("Successfully loaded problem " .. selection.value.id .. " - " .. selection.value.name)
            end)
            return true
        end,
    }):find()
end

-- Function to submit the current solution
function M.submit()
    if not M.contest_id or not M.current_problem then
        print("No problem selected. Use 'cf show' to select a problem first.")
        return
    end

    if not handle_login() then
        return
    end

    local pickers = require "telescope.pickers"
    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"

    local custom_theme = require("telescope.themes").get_dropdown({
        width = M.config.telescope_config.width,
        height = M.config.telescope_config.height,
        previewer = false,
    })

    pickers.new(custom_theme, {
        prompt_title = "Select file to submit",
        finder = finders.new_oneshot_job({"find", ".", "-type", "f"},
            {cwd = vim.fn.getcwd()}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                submit_solution(selection[1])
            end)
            return true
        end,
    }):find()
end

-- Function to exit the Codeforces session
function M.exit()
    if M.contest_id then
        M.contest_id = nil
        M.problems = {}
        M.logged_in = false
        print("Codeforces session exited. Use 'cf start' to begin a new session.")
    else
        print("No active Codeforces session.")
    end
end

-- Setup function to allow user configuration
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
