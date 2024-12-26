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
				--"ts_ls",
				"html",
				"css",
				"tailwindcss",
				"gopls",
				"templ",
				"htmx-lsp",
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
				"gitlab_ci_ls",
			},
			automatic_installation = true,
		})
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"eslint_d",
				"eslint", -- not sure with the eslint_d
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
