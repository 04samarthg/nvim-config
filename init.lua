-- ~/.config/nvim/init.lua
require("core")

-- Auto-save input1.txt on text change
vim.cmd([[
  autocmd BufWritePost /home/pheonix/cp/ipf.in :wa
  autocmd TextChanged,TextChangedI /home/pheonix/cp/ipf.in silent! write
]])

if vim.g.CheckUpdateStarted == nil then
    vim.g.CheckUpdateStarted = 1
    vim.fn.timer_start(1, function()
        CheckUpdate()
    end)
end

function CheckUpdate()
    vim.cmd('silent! checktime')
    vim.fn.timer_start(1000, function()
        CheckUpdate()
    end)
end

-- ─────────────────── Load cp_templates configuration ───────────────────

local cp_templates = require('cp_templates')

cp_templates.setup({})

-- Define commands
vim.api.nvim_create_user_command('CPTemplate', function(opts)
    if opts.args ~= "" then
        cp_templates.insert_template(opts.args)
    else
        cp_templates.select_and_insert_template()
    end
end, {nargs = "?"})

-- ------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "plugins" }, { import = "plugins.lsp" }, { import = "plugins.colorscheme" },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
