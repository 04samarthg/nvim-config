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

            -- Option 1: coc.nvim as LSP client
            -- Uncomment the below lines if using coc.nvim
            -- {
            --     'neoclide/coc.nvim',
            --     branch = 'master',
            --     build = 'yarn install --frozen-lockfile',
            -- }

            -- Option 2: nvim lsp as LSP client
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require("lspconfig")[ls].setup({
                    capabilities = capabilities,
                    -- you can add other fields for setting up lsp server in this table
                })
            end

            -- Option 3: treesitter as a main provider instead
            -- (Note: the nvim-treesitter plugin is not needed.)
            -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
            -- performance and stability are better than foldmethod=nvim_treesitter#foldexpr()
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
            })

            -- Option 4: disable all providers for all buffers
            -- Not recommend, AFAIK, the ufo's providers are the best performance in Neovim
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return ""
                end,
            })
        end,
    },
}

