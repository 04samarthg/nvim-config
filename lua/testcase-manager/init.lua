-- lua/testcase-manager/init.lua
local Job = require('plenary.job')
local curl = require('plenary.curl')

local M = {}
local server_job = nil
local server_ready = false
local shutdown_in_progress = false
local MAX_RETRIES = 5
local RETRY_DELAY = 1000 -- ms
local SERVER_PORT = 10043

-- Function to check if port is in use
local function is_port_in_use()
    local handle = io.popen(string.format("lsof -i:%d -t", SERVER_PORT))
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= ""
    end
    return false
end

-- Function to kill existing process on port
local function kill_existing_process()
    local handle = io.popen(string.format("lsof -i:%d -t | xargs kill -9", SERVER_PORT))
    if handle then
        handle:close()
    end
end

-- Function to check if server is responding
local function check_server()
    if shutdown_in_progress then
        return false
    end

    local response = curl.get('http://localhost:' .. SERVER_PORT .. '/testcases', {
        timeout = 1000, -- 1 second timeout
    })
    return response.status == 200
end

-- Function to wait for server with retries
local function wait_for_server(callback, retries)
    retries = retries or 0

    if shutdown_in_progress then
        return
    end

    if retries >= MAX_RETRIES then
        vim.notify('Server failed to start after multiple retries', vim.log.levels.ERROR)
        server_ready = false
        return
    end

    vim.defer_fn(function()
        if check_server() then
            server_ready = true
            if callback then callback() end
        else
            wait_for_server(callback, retries + 1)
        end
    end, RETRY_DELAY)
end

-- Function to start the server
local function start_server(callback)
    if shutdown_in_progress then
        vim.defer_fn(function()
            start_server(callback)
        end, RETRY_DELAY)
        return
    end

    if server_job and server_ready then
        if callback then callback() end
        return
    end

    -- Clear any existing processes
    if is_port_in_use() then
        kill_existing_process()
        -- Wait a bit for the port to be freed
        vim.defer_fn(function()
            start_server(callback)
        end, 1000)
        return
    end

    -- Ensure server.js exists
    local server_path = '/home/phoenix/.config/nvim/lua/testcase-manager/cfListener/index.js'
    if vim.fn.filereadable(server_path) == 0 then
        vim.notify('server.js not found at: ' .. server_path, vim.log.levels.ERROR)
        return
    end

    server_job = Job:new({
        command = 'node',
        args = { server_path },
        on_exit = function(j, return_val)
            if not shutdown_in_progress and return_val ~= 0 then
                vim.notify('Server process exited with code: ' .. return_val, vim.log.levels.ERROR)
                server_ready = false
                server_job = nil
                -- Attempt to restart server after unexpected exit
                vim.defer_fn(function()
                    start_server()
                end, RETRY_DELAY)
            end
        end,
        on_stderr = function(_, data)
            if data and data ~= "" and not shutdown_in_progress then
                vim.notify('Server error: ' .. data, vim.log.levels.ERROR)
            end
        end
    })

    server_job:start()
    wait_for_server(callback)
end

-- Function to stop the server
local function stop_server(callback)
    shutdown_in_progress = true

    if server_job then
        -- Kill any processes that might be using the port
        kill_existing_process()

        server_job:shutdown()
        server_job = nil
        server_ready = false

        if not shutdown_in_progress then
            vim.notify('Test case server stopped', vim.log.levels.INFO)
        end
    end

    if callback then
        vim.defer_fn(callback, 1000)
    end

    shutdown_in_progress = false
end

-- Function to fetch test cases from server with retry
local function fetch_test_cases()
    if not server_ready then
        vim.notify('Server not ready, retrying...', vim.log.levels.WARN)
        start_server(M.pick_test_case)
        return {}
    end

    local response = curl.get('http://localhost:' .. SERVER_PORT .. '/testcases', {
        timeout = 2000 -- 2 second timeout
    })

    if response.status ~= 200 then
        vim.notify('Failed to fetch test cases', vim.log.levels.ERROR)
        return {}
    end

    local status, test_cases = pcall(vim.fn.json_decode, response.body)
    if not status then
        vim.notify('Failed to parse test cases', vim.log.levels.ERROR)
        return {}
    end

    return test_cases
end

-- Function to write selected test case to input file
local function write_test_case(test_case)
    local file = io.open('/home/phoenix/cp/ipf.in', 'w')
    if file then
        file:write(test_case.input)
        file:write('\nExpected Output:\n' .. test_case.output)
        file:close()
        vim.notify('Test case ' .. test_case.id .. ' written to ipf.in', vim.log.levels.INFO)
    else
        vim.notify('Failed to write input file', vim.log.levels.ERROR)
    end
end

-- New function to directly navigate to a test case by number
local function navigate_to_testcase(number)
    return function()
        if not server_ready then
            vim.notify('Starting server...', vim.log.levels.INFO)
            start_server(function()
                navigate_to_testcase(number)()
            end)
            return
        end

        local test_cases = fetch_test_cases()

        if #test_cases == 0 then
            vim.notify('No test cases available', vim.log.levels.WARN)
            return
        end

        -- Find the test case with matching ID
        for _, test_case in ipairs(test_cases) do
            if test_case.id == number then
                write_test_case(test_case)
                return
            end
        end

        vim.notify('Test case ' .. number .. ' not found', vim.log.levels.WARN)
    end
end

-- Create test case picker
function M.pick_test_case()
    if not server_ready then
        vim.notify('Starting server...', vim.log.levels.INFO)
        start_server(M.pick_test_case)
        return
    end

    local test_cases = fetch_test_cases()

    if #test_cases == 0 then
        return
    end

    if pcall(require, "snacks") then
        -- Convert test cases to picker items
        local items = {}
        for _, test_case in ipairs(test_cases) do
            local line_count = select(2, test_case.input:gsub('\n', '\n')) + 1
            table.insert(items, {
                text = string.format("TC %d (%d lines)", test_case.id, line_count),
                test_case = test_case,
            })
        end

        Snacks.picker.pick({
            prompt = "Test Cases",
            title = "Test Cases",
            items = items,
            format = function(item)
                return { { item.text } }
            end,
            layout = {
                preset = "vertical",
                width = 0.3,
                height = 0.4,
            },
            actions = {
                confirm = function(picker, item)
                    picker:close()
                    write_test_case(item.test_case)
                end,
            },
        })
    else
        -- Fallback to vim.ui.select
        vim.ui.select(test_cases, {
            prompt = "Test Cases",
            format_item = function(test_case)
                local line_count = select(2, test_case.input:gsub('\n', '\n')) + 1
                return string.format("TC %d (%d lines)", test_case.id, line_count)
            end,
        }, function(choice)
            if choice then
                write_test_case(choice)
            end
        end)
    end
end

-- Setup function
function M.setup(opts)
    opts = opts or {}

    -- Create user commands
    vim.api.nvim_create_user_command('TestCasePicker', function()
        M.pick_test_case()
    end, {})

    vim.api.nvim_create_user_command('TestCaseServerRestart', function()
        stop_server(function()
            start_server(function()
                vim.notify('Server restarted successfully', vim.log.levels.INFO)
            end)
        end)
    end, {})

    -- Set up telescope picker keymapping
    if opts.keymap then
        vim.keymap.set('n', opts.keymap, function() M.pick_test_case() end, { desc = 'Pick test case' })
    end

    -- Set up direct navigation keymaps (1-9)
    for i = 1, 9 do
        vim.keymap.set('n', '<M-' .. i .. '>', navigate_to_testcase(i), { desc = 'Load Test Case ' .. i })
    end

    -- Ensure server is stopped when Neovim exits
    vim.api.nvim_create_autocmd('VimLeavePre', {
        pattern = '*',
        callback = function()
            stop_server()
        end,
        group = vim.api.nvim_create_augroup('TestCaseManagerCleanup', { clear = true })
    })

    -- Start server on setup
    start_server(function()
        vim.notify('Test case server started', vim.log.levels.INFO)
    end)
end

return M
