-- A snazzy bufferline for Neovim
return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- version = "*",
	branch = "main",
	opts = {
		options = {
			-- mode = "buffers",
			mode = "tabs",
			separator_style = "slant",
			diagnostics = "nvim_lsp",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					separator = true,
				},
			},
		},
	},
}
