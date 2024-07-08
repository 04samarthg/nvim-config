return {
  "luukvbaal/statuscol.nvim",
  dependencies = { "lewis6991/gitsigns.nvim" },
  config = function()
    local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        ft_ignore = { "alpha", "nvim-tree", "oil", "Lazy", "Mason" },
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          {
            sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, auto = false },
            click = "v:lua.ScSa"
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
          { sign = { namespace = { "gitsign" }, auto = false, maxwidth = 1, colwidth = 1, } },
        },
      })
  end,
}
