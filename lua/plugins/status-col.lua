return {
  "luukvbaal/statuscol.nvim",
  dependencies = { "lewis6991/gitsigns.nvim" },
  event = "BufReadPost",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      ft_ignore = { "alpha", "nvim-tree", "oil", "Lazy", "Mason" },
      segments = {
        { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa", auto = true },
        {
          sign = { namespace = { "diagnostic" }, auto = false },
          click = "v:lua.ScSa"
        },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        { sign = { namespace = { "gitsign" }, auto = false, maxwidth = 1, colwidth = 1, } },
      },
    })
  end,
}
