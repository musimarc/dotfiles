return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				--"tsserver",
				"html",
				"css-lsp",
				"tailwindcss",
				"gopls",
				"templ",
				--"htmx-lsp",
				"astro",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"terraformls",
				"vuels",
				"marksman",
				"prismals",
				"helm_ls",
				"jsonls",
				"autotools_ls",
				"taplo",
				"dockerls",
			},
			automatic_installation = true,
		})
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"eslint",
				"tflint",
				"tfsec",
				"mdformat",
				"pylint",
				"isort", -- python formatter
				"black", -- python formatter
			},
		})
	end,
}
