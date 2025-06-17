return {

    -- A dark and light theme ported from the Visual Studio Code TokyoNight theme.
    -- {
    --   "folke/tokyonight.nvim",
    --   lazy = false,
    --   priority = 1000,
    --   opts = {},
    -- },
    -- },
     -- { "rose-pine/neovim", name = "rose-pine-moon" },
    --  {
    --    'EdenEast/nightfox.nvim',
    --    config = function()
    --      require('nightfox').setup({
    --        options = {
    --          styles = {
    --            comments = "italic",
    --            keywords = "bold",
    --            types = "italic,bold",
    --          }
    --        }
    --      })
    --      vim.cmd("colorscheme carbonfox")
    --    end
    --  },
    --  {  "rebelot/kanagawa.nvim",
    --        config = function()
    --            require('kanagawa').setup({
    --                colors = {
    --                    wave = {
    --                      ui = {
    --                        float = {
    --                          bg = "none",
    --                        }
    --                      }
    --                    },
    --                    theme = {
    --                        all = {
    --                            ui = {
    --                                bg_gutter = "none",
    --                            }
    --                        }
    --                    }
    --                },
    --                transparent = true,
    --                overrides = function(colors)
    --                    local theme = colors.theme
    --                    return {
    --                        -- Existing Pmenu overrides
    --                        Pmenu = { fg = theme.ui.shade1, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
    --                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
    --                        PmenuSbar = { bg = theme.ui.bg_p1 },
    --                        PmenuThumb = { bg = theme.ui.bg_p2 },
    --
    --                        -- Telescope overrides
    --                        TelescopeTitle = { fg = theme.ui.special, bold = true },
    --                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
    --                        TelescopePromptBorder = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
    --                        TelescopeResultsNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    --                        TelescopeResultsBorder = { fg = theme.ui.bg_p5, bg = theme.ui.bg_m3 },
    --                        TelescopePreviewNormal = { bg = theme.ui.bg_m3 },
    --                        TelescopePreviewBorder = { bg = theme.ui.bg_m3, fg = theme.ui.bg_p5 },
    --
    --                        -- NvimTree overrides
    --                        NvimTreeNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    --                        -- NvimTreePopup = { bg = theme.ui.bg_p1 },
    --
    --                        -- New float window overrides
    --                        NormalFloat = { bg = theme.ui.bg_p1 },
    --                        FloatBorder = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
    --                        FloatTitle = { fg = theme.ui.special, bold = true },
    --                        -- Custom dark background group
    --                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
    --                        -- Plugin-specific float window settings
    --                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    --                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
    --                        -- Additional overrides can be added here
    --                        Normal = { fg = theme.ui.fg, bg = theme.ui.bg },
    --                        Comment = { fg = theme.ui.comment, italic = true },
    --                    }
    --                end,
    --            })
    --            vim.cmd("colorscheme kanagawa-wave")
    --        end,
    --  },
    --
    --  {
    --    "catppuccin/nvim",
    --    lazy = false,
    --    name = "catppuccin",
    --    priority = 1000,
    --    config = function()
    --      vim.cmd.colorscheme "catppuccin-mocha"
    --    end
    --  },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('cyberdream').setup({
                borderless_telescope = true,
                transparent = false,
                hide_fillchars = true,
                -- theme = {
                colors = {
                    bg = "#1e1e2e",
                },
                overrides = function(colors)
                    return {
                        BufferLineFill = { bg = colors.popup_bg },
                    }
                end,
                -- },
            })

            vim.cmd.colorscheme "cyberdream"
                vim.api.nvim_set_hl(0, "StatusColumn", { bg = "#000000" })  -- or any dark hex color
        end,
    }

}
