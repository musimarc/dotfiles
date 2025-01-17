return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			presets = {
				-- This is the search bar or popup that shows up when you press /
				-- Setting this to false makes it a popup and true the search bar at the bottom
				bottom_search = false,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
}
