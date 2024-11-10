return {
  'echasnovski/mini.animate',
  version = false,
  event = "BufReadPost",
  config = function()
    

    require('mini.animate').setup({
      cursor = {
      },
      scroll = {
        enable = false,
      },
      resize = {
        enable = false,
      },
      open = {
        enable = false,
      },
      close = {
        enable = false,
      },
    })
  end
}
