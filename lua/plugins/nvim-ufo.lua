return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            -- Neovim options for folding
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Key mappings for folding
            vim.keymap.set("n", "zo", require("ufo").openAllFolds)
            vim.keymap.set("n", "zc", require("ufo").closeAllFolds)

            -- Custom key mapping for preview
            vim.keymap.set("n", "zp", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    -- no preview available
                    print("No preview available")
                end
            end)

            -- UFO setup with various configurations
            require("ufo").setup({
                open_fold_hl_timeout = 400,
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
                close_fold_kinds_for_ft = {
                    default = { "comment", "imports", "region" },
                },
                fold_virt_text_handler = nil, -- Customize this function if needed
                enable_get_fold_virt_text = false,
                preview = {
                    win_config = {
                        border = "rounded",
                        winblend = 12,
                        winhighlight = "Normal:Normal",
                        maxheight = 20,
                        width = 50,
                    },
                    mappings = {
                        -- Add your key mappings here
                        ["scrollU"] = "<C-u>",
                        ["scrollD"] = "<C-d>",
                        ["scrollUp"] = "<Up>",
                        ["scrollDown"] = "<Down>",
                        ["closePreview"] = "<Esc>",
                    },
                },
            })

        end,
    },
}
