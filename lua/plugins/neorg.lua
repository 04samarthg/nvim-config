return {
    "nvim-neorg/neorg",
    dependencies = { "nvim-lua/plenary.nvim", "vhyrro/luarocks.nvim" },
    build = ":Neorg sync-parsers",
    config = function()
        require("neorg").setup({
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.concealer"] = {
                    config = {
                        icons = {
                            todo = {
                                done = { icon = "" },
                                pending = { icon = "" },
                            },
                        },
                    },
                },
                ["core.completion"] = { config = { engine = "nvim-cmp" } },
                ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
                ["core.itero"] = {},
                ["core.ui.calendar"] = {},
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            work = "~/notes/work",
                            home = "~/notes/home",
                        },
                        default_workspace = "home",
                    },
                },
            },
        })
        -- Run sync-parsers after setup
        -- vim.cmd("Neorg sync-parsers")
    end,
}
