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
    { "<leader>cr", function() Snacks.rename.rename_file() end,         desc = "Rename File" },
    { "<leader>un", function() Snacks.notifier.hide() end,              desc = "Dismiss All Notifications" },
    { "<leader>ff", function() Snacks.picker.files() end,               desc = "Fuzzy find files in cwd" },
    { "<leader>fr", function() Snacks.picker.recent() end,              desc = "Fuzzy find recent files" },
    { "<leader>fs", function() Snacks.picker.grep() end,                desc = "Find string in cwd" },
    { "<leader>fc", function() Snacks.picker.grep_word() end,           desc = "Find string under cursor in cwd" },
    { "<leader>su", function() Snacks.picker.undo() end,                desc = "Undo History" },
    { "<leader>gs", function() Snacks.picker.git_status() end,          desc = "Git Status" },
    { "<leader>gl", function() Snacks.picker.git_log() end,             desc = "Git Log" },
    { "<leader>gb", function() Snacks.picker.git_branches() end,        desc = "Git Branches" },
    { "<leader>gd", function() Snacks.picker.git_diff() end,            desc = "Git Diff (Hunks)" },
    { "<leader>fj", function() Snacks.picker.smart() end,               desc = "Smart Find Files" },
    { "gd",         function() Snacks.picker.lsp_definitions() end,     desc = "Goto Definition" },
    { "gr",         function() Snacks.picker.lsp_references() end,      desc = "References" },
    { "gI",         function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,         desc = "LSP Symbols" },
  }
}
