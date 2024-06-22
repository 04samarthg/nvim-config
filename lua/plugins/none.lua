return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		local ast_grep = {
			method = null_ls.methods.DIAGNOSTICS,
			filetypes = { "cpp", "java", "html", "lua", "php", "javascript", "typescript", "jsx", "tsx" },
			generator = {
				fn = function(params)
					local diagnostics = {}
					local output = vim.fn.system("ast-grep --json --stdin", params.content)

					if vim.v.shell_error ~= 0 then
						return diagnostics
					end

					local ok, result = pcall(vim.json.decode, output)
					if not ok then
						return diagnostics
					end

					for _, diag in ipairs(result.diagnostics) do
						table.insert(diagnostics, {
							row = diag.line,
							col = diag.column,
							end_row = diag.endLine,
							end_col = diag.endColumn,
							source = "ast-grep",
							message = diag.message,
							severity = diag.severity,
						})
					end

					return diagnostics
				end,
			},
		}

		null_ls.setup({
			sources = {
				-- Add Lua formatter (Stylua)
				null_ls.builtins.formatting.stylua,

				-- Add PHP linter (phpcs)
				null_ls.builtins.diagnostics.phpcs,

				-- Add JavaScript/TypeScript formatter (Prettier)
				null_ls.builtins.formatting.prettier,

				-- Add C++ formatter (clang_format)
				-- null_ls.builtins.formatting.clang_format,

				-- Add Java formatter (google_java_format)
				null_ls.builtins.formatting.google_java_format,

				-- Add HTML formatter (Prettier)
				null_ls.builtins.formatting.prettier.with({
					filetypes = { "html" },
				}),

				-- Add custom ast-grep source
				ast_grep,
			},
		})

		-- Map <leader>gf to format the buffer using LSP
		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "Format Code" })
	end,
}
