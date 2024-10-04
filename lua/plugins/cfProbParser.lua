
return {
    dir = vim.fn.stdpath("config") .. "/lua/cfProbParser",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local codeforces = require("cfProbParser")
        vim.api.nvim_create_user_command("CFStart", codeforces.start, {})
        vim.api.nvim_create_user_command("CFShow", codeforces.show, {})
        vim.api.nvim_create_user_command("CFExit", codeforces.exit, {})
    end,
}
