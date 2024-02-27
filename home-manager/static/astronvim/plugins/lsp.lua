local null_ls = require("null-ls")
table.insert(null_ls.builtins.formatting.prettier.filetypes, "solidity")

return {
	{
		"jay-babu/mason-null-ls.nvim",
		opts = {
			ensure_installed = {
				"black",
				"buf",
				"eslint-lsp",
				"gofumpt",
				"goimports",
				"gopls",
				"ltex-ls",
				"marksman",
				"nil",
				"prettier",
				"pyright",
				"rust-analyzer",
				"solhint",
				"stylua",
				"typescript-language-server",
			},
		},
	},
}
