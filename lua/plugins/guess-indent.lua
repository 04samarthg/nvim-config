return {
  'nmac427/guess-indent.nvim',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('guess-indent').setup {}
    local default_config = {
      auto_cmd = false
    }
    vim.cmd([[ autocmd BufReadPost * :silent! GuessIndent ]])
  end,
}
