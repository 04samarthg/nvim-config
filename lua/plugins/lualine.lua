
return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            -- Import Kanagawa colors
            local theme = require("kanagawa.colors").setup().theme

            -- Define Kanagawa colors for lualine
            local kanagawa = {
                normal = {
                    a = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
                    b = { bg = theme.diff.change, fg = theme.syn.fun },
                    c = { bg = theme.ui.bg_p1, fg = theme.ui.fg },
                },
                insert = {
                    a = { bg = theme.diag.ok, fg = theme.ui.bg },
                    b = { bg = theme.ui.bg, fg = theme.diag.ok },
                },
                command = {
                    a = { bg = theme.syn.operator, fg = theme.ui.bg },
                    b = { bg = theme.ui.bg, fg = theme.syn.operator },
                },
                visual = {
                    a = { bg = theme.syn.keyword, fg = theme.ui.bg },
                    b = { bg = theme.ui.bg, fg = theme.syn.keyword },
                },
                replace = {
                    a = { bg = theme.syn.constant, fg = theme.ui.bg },
                    b = { bg = theme.ui.bg, fg = theme.syn.constant },
                },
                inactive = {
                    a = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    b = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim, gui = "bold" },
                    c = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                },
            }

            -- Make 'a' mode bold if kanagawa_lualine_bold is set
            if vim.g.kanagawa_lualine_bold then
                for _, mode in pairs(kanagawa) do
                    mode.a.gui = "bold"
                end
            end

            -- Set up lualine with Kanagawa colors
            require('lualine').setup({
                options = {
                    theme = kanagawa,
                },
            })
        end
    }
}
