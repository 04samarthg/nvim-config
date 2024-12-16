-- return {
--   {
--     "williamboman/mason.nvim",
--     event = "BufReadPost",
--     config = function()
--       require("mason").setup({
--         ui = {
--           icons = {
--             package_installed = "✓",
--             package_pending = "➜",
--             package_uninstalled = "✗",
--           },
--         },
--       })
--     end,
--   },
--
--   {
--     "williamboman/mason-lspconfig.nvim",
--     event = "BufReadPost",
--     config = function()
--       require("mason-lspconfig").setup({
--         ensure_installed = {
--           "html",
--           "cssls",
--           "tailwindcss",
--           "lua_ls",
--           "pyright",
--         },
--       })
--     end,
--   },
--
--   {
--     "WhoIsSethDaniel/mason-tool-installer.nvim",
--     event = "BufReadPost",
--     config = function()
--       require("mason-tool-installer").setup({
--         ensure_installed = {
--           "prettier", -- prettier formatter
--           "stylua",   -- lua formatter
--           "black",    -- python formatter
--           "pylint",   -- python linter
--           "eslint_d", -- js linter
--           "codelldb",
--         },
--       })
--     end,
--   },
-- }
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  -- event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "pyright",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "black", -- python formatter
        "pylint", -- python linter
        "eslint_d", -- js linter
      },
    })
  end,
}
