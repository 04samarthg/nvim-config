return {
  "nvim-lua/plenary.nvim",-- lua functions that many plugins use
  { 
    'echasnovski/mini.animate', 
    config = function ()
      require('mini.animate').setup({scroll = { enable = false },})
    end
  },
  "xiyaowong/transparent.nvim",
  {
    'nmac427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {}
      local default_config = {
        auto_cmd = false
      }
      vim.cmd([[ autocmd BufReadPost * :silent GuessIndent ]])
    end,
  },
  {
    'github/copilot.vim'
  },
}
