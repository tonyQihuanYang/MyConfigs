-- LSP Configuration

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = require("lsp.defaults").on_attach

-- add completion capability
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Terraform
-- brew install terraform-ls
lspconfig.terraformls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- npm install -g typescript typescript-language-server
lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
--   pattern = {"*.tf", "*.tfvars"},
--   callback = vim.lsp.buf.format(),
-- })
-- End Terraform




-- brew install lua-language-server
lspconfig['lua_ls'].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  }
}

-- lspconfig['ltex'].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc" },
--   settings = {
--     ltex = {
--       language = "en-CA",
--     }
--   }
-- }
--
-- lspconfig['gopls'].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     gopls = {
--       analyses = {
--         unusedparams = true,
--       },
--       staticcheck = true,
--     },
--   }
-- }
--
-- lspconfig['pyright'].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     pyright = {
--       analysis = {
--         useLibraryCodeForTypes = true,
--       },
--     },
--   }
-- }

-- lspconfig['solargraph'].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }

-- lspconfig['dartls'].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
