return {
	-- You can also add new plugins here as well:
	-- Add plugins, the lazy syntax
	-- "andweeb/presence.nvim",
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},
	{
		"phaazon/hop.nvim",
		lazy = false,
		config = function()
			require("hop").setup()
		end,
	},
	{
		"junegunn/vim-easy-align",
		lazy = false,
	},
	{
		"ruifm/gitlinker.nvim",
		lazy = false,
		config = function()
			require("gitlinker").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		lazy = false,
		config = function()
			require("nvim-surround").setup()
		end,
	},
	{
		"numToStr/Navigator.nvim",
		lazy = false,
		config = function()
			require("Navigator").setup()
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 2000,
			top_down = false,
			max_width = 40,
			minimum_width = 20,
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				path_display = { shorten = 3 },
			},
		},
	},
	{
		"github/copilot.vim",
		event = "InsertEnter",
	},
	{
		"hrsh7th/nvim-cmp",
		-- override the options table that is used in the `require("cmp").setup()` call
		opts = function(_, opts)
			-- opts parameter is the default options table
			-- the function is lazy loaded so cmp is able to be required
			local cmp = require("cmp")
			-- modify the mapping part of the table
			opts.mapping["<C-j>"] = cmp.mapping(function(fallback)
				local copilot_keys = vim.fn["copilot#Accept"]()

				if copilot_keys ~= "" and type(copilot_keys) == "string" then
					vim.api.nvim_feedkeys(copilot_keys, "i", true)
				elseif cmp.visible() then
					cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				end
			end)

			opts.experimental = { ghost_text = false }

			-- return the new table to be used
			return opts
		end,
	},
}
