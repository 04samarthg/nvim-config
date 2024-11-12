return {
  {
    "williamboman/mason.nvim",
    event = "BufReadPost",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    -- after = "mason.nvim",
    event = "BufReadPost",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "html",
          "cssls",
          "tailwindcss",
          "lua_ls",
          "pyright",
        },
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- after = { "mason.nvim"},
    event = "BufReadPost",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua",   -- lua formatter
          "black",    -- python formatter
          "pylint",   -- python linter
          "eslint_d", -- js linter
          "codelldb",
        },
      })
    end,
  },
}
