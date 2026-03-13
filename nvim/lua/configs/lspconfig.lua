require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright", "ts_ls", "terraformls" }
vim.lsp.enable(servers)

-- terraform format-on-save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
