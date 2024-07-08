return {
  "nvim-lua/plenary.nvim",-- lua functions that many plugins use
  { 
    'echasnovski/mini.animate', 
    config = function ()
      require('mini.animate').setup({scroll = { enable = false },})
    end
  }, 
}
