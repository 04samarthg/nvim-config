return {
  "windwp/nvim-ts-autotag",
  dependencies={  
	  "nvim-treesitter/nvim-treesitter",
  },
  ft = {"html", "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx", "jsx"}, 
  config=function ()
    require("nvim-ts-autotag").setup()
    -- enable autotagging (w/ nvim-ts-autotag plugin)
			local autotag = {
				enable = true,
        filetypes = {
          'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
          'css', 'lua', 'xml', 'php', 'markdown'
        },
			}
  end,
}
