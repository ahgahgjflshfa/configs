return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "pylsp" }
            })
        end
    },
    {
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
		
			-- 延遲 100 毫秒設置 LSP，以確保環境變數和插件已完全加載
			vim.defer_fn(function()
				local lspconfig = require("lspconfig")
				
				-- 配置 Lua 語言伺服器
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = {
								version = 'LuaJIT',
								path = vim.split(package.path, ';'),
							},
							diagnostics = {
								globals = {'vim'},
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = {
								enable = false,
							},
						}
					}
				})

				-- Python 設置
				lspconfig.pylsp.setup({
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							}
						}
					}
				})

				-- JavaScript/TypeScript 設置
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
					settings = {
						completions = {
							completeFunctionCalls = true, -- 補全時自動加上函數的圓括號
						},
					},
					on_attach = function(client, bufnr)
						-- 如果只想讓 tsserver 處理 JS/TS 文件，可以在這裡禁用對其他文件類型的支援
						client.resolved_capabilities.document_formatting = false
					end
				})

				-- 按鍵映射
				vim.keymap.set("n", "O", vim.lsp.buf.hover, { desc = "LSP Hover" })
				vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
				vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find References" })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
			end, 100) -- 延遲 100 毫秒
		end
    },
}
