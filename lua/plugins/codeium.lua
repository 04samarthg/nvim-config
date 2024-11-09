return{
    "Exafunction/codeium.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    event = "BufReadPost",
    config = function()
        require("codeium").setup({
        })
    end
}
