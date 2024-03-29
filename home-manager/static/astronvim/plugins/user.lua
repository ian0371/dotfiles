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
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		-- override the options table that is used in the `require("cmp").setup()` call
		opts = function(_, opts)
			-- opts parameter is the default options table
			-- the function is lazy loaded so cmp is able to be required
			opts.experimental = { ghost_text = false }
			opts.sources = {
				-- Copilot Source
				{ name = "copilot", group_index = 2 },
				-- Other Sources
				{ name = "nvim_lsp", group_index = 2 },
				{ name = "path", group_index = 2 },
				{ name = "luasnip", group_index = 2 },
			}

			-- return the new table to be used
			return opts
		end,
	},
	{
		"andymass/vim-matchup",
		lazy = false,
		setup = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		cmd = "Grapple",
		keys = {
			{ "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
			{ "<leader>k", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },
			{ "<leader>K", "<cmd>Grapple toggle_scopes<cr>", desc = "Grapple toggle scopes" },
			{ "<leader>j", "<cmd>Grapple cycle forward<cr>", desc = "Grapple cycle forward" },
			{ "<leader>J", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },
			{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple select 1" },
			{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple select 2" },
			{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple select 3" },
			{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple select 4" },
		},
	},
	{
		"gbprod/substitute.nvim",
		event = "BufRead",
		config = function()
			require("substitute").setup()
		end,
	},
}
