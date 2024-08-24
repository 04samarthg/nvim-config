return {
  "nvim-lua/plenary.nvim",-- lua functions that many plugins use

  {
    'echasnovski/mini.animate',
    config = function ()
      require('mini.animate').setup({scroll = { enable = false },})
    end
  },

  "xiyaowong/transparent.nvim",

  { 'echasnovski/mini.ai', version = false },

  'mg979/vim-visual-multi',

}
