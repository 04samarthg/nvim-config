return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "onsails/lspkind-nvim",
    "roobert/tailwindcss-colorizer-cmp.nvim",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "mlaursen/vim-react-snippets",
  },

  config = function()
    local cmp = require("cmp")
    require("luasnip.loaders.from_vscode").lazy_load()
    require("vim-react-snippets").lazy_load()

    local lsp_kind = require("lspkind")
    local cmp_next = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end
    local cmp_prev = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end

    lsp_kind.init()

    local formatting_style = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, item)
        local icon = lsp_kind.presets.default[item.kind]
        if icon then
          icon = " " .. icon .. " "
        else
          icon = " "
        end

        local lspkind_text = ({
          codeium = "[cod]",
          nvim_lsp = "[LSP]",
          luasnip = "[snp]",
          buffer = "[buf]",
          nvim_lua = "[lua]",
          path = "[path]",
        })[entry.source.name]

        item.menu = lspkind_text and "   (" .. item.kind .. ")" or ""
        item.kind = icon

        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end,
    }

    local function too_big(bufnr)
      local max_filesize = 10 * 1024 -- 100 KB
      local check_stats = (vim.uv or vim.loop).fs_stat
      local ok, stats = pcall(check_stats, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max_filesize then
        return true
      else
        return false
      end
    end
    
    local preferred_sources = {
      { name = "codeium", max_item_count = 3, group_index = 1},
      { name = "nvim_lsp_signature_help", group_index = 1 },
      { name = "nvim_lsp", max_item_count = 20, group_index = 1 },
      { name = "luasnip", max_item_count = 5, group_index = 1 },
      { name = "nvim_lua", group_index = 1 },
      { name = "path", group_index = 2 },
    }

    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpBufferDisableGrp", { clear = true }),
      callback = function(ev)
        local sources = preferred_sources
        if not too_big(ev.buf) then
          sources[#sources + 1] = { name = "buffer", keyword_length = 4 }
        end
        cmp.setup.buffer({
          sources = cmp.config.sources(sources),
        })
      end,
    })

    cmp.setup({
      performance = {
        max_view_entries = 10,
      },
      view = {
        entries = { name = "custom", selection_order = "near_cursor" },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<tab>"] = cmp_next,
        ["<C-p>"] = cmp_prev,
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = formatting_style,

      sources = cmp.config.sources(vim.tbl_extend("force", preferred_sources, {
        { name = "buffer", keyword_length = 4 },
      })),
    })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })
    
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
}
