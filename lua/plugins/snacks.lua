return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = function()
    return {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
        top_down = false,
        style = "compact",
      },
      image = { enabled = true },
      quickfile = { enabled = true },
      picker = require("plugins.snacks.picker"),
      dashboard = require("plugins.snacks.dashboard"),
    }
  end,
  keys = {
    { "<leader>lg", function() Snacks.lazygit() end,                    desc = "Lazygit" },
    { "<leader>n",  function() Snacks.notifier.show_history() end,      desc = "Notification History" },
    { "<leader>rn", function() Snacks.rename.rename_file() end,         desc = "Rename File" },
    { "<leader>nu", function() Snacks.notifier.hide() end,              desc = "Dismiss All Notifications" },
    { "<leader>a",  function() Snacks.picker.files() end,               desc = "Fuzzy find files in cwd" },
    { "<leader>fr", function() Snacks.picker.recent() end,              desc = "Fuzzy find recent files" },
    { "<leader>fs", function() Snacks.picker.grep() end,                desc = "Find string in cwd" },
    { "<leader>fc", function() Snacks.picker.grep_word() end,           desc = "Find string under cursor in cwd" },
    { "<leader>u",  function() Snacks.picker.undo() end,                desc = "Undo History" },
    { "<leader>gs", function() Snacks.picker.git_status() end,          desc = "Git Status" },
    { "<leader>gl", function() Snacks.picker.git_log() end,             desc = "Git Log" },
    { "<leader>gb", function() Snacks.picker.git_branches() end,        desc = "Git Branches" },
    { "<leader>gd", function() Snacks.picker.git_diff() end,            desc = "Git Diff (Hunks)" },
    { "gd",         function() Snacks.picker.lsp_definitions() end,     desc = "Goto Definition" },
    { "gr",         function() Snacks.picker.lsp_references() end,      desc = "References" },
    { "gI",         function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    {
        "mm",
        function()
          Snacks.picker.buffers({
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            layout = "vertical",
            sort_lastused = true,
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                },
              },
              list = { keys = { ["d"] = "bufdelete" } },
            },
          })
        end,
        desc = "[P]Snacks picker buffers",
      },
  }
}
