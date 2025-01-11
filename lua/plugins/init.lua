return {
  "nvim-lua/plenary.nvim",
  {
    'mg979/vim-visual-multi',
    event = "BufReadPost",
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = "BufReadPost",
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
}
