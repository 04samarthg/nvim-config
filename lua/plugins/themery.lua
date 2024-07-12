return{
  'zaldih/themery.nvim',
  config = function()
      require("themery").setup({
        themes = {"kanagawa", "catppuccin-mocha", "tokyonight", "rose-pine-moon", "carbonfox"}, -- Your list of installed colorschemes
        themeConfigFile = "~/.config/nvim/lua/plugins/colorscheme/theme.lua", -- Described below
        livePreview = true, -- Apply theme while browsing. Default to true.
      })
  end
}
