return {
  'rcarriga/nvim-notify',
  priority = 9000,
  config = function()
    local nvim_notify = require("notify")
    nvim_notify.setup {
      -- Animation style
      stages = "static",
      render = "compact",
      top_down = false,
      -- max_height = function()
      --   return math.floor(vim.o.lines * 0.85)
      -- end,
      -- max_width = function()
      --   return math.floor(vim.o.columns * 0.40)
      -- end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      timeout = 2500,
    }
    
    vim.notify = nvim_notify
  end,
}
