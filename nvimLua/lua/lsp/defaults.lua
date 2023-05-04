local remap = require("me.util").remap

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  remap('n', 'gD', vim.lsp.buf.declaration, bufopts, "Go to declaration")
  remap('n', 'gd', vim.lsp.buf.definition, bufopts, "Go to definition")
  remap('n', 'gi', vim.lsp.buf.implementation, bufopts, "Go to implementation")
  remap('n', 'K', vim.lsp.buf.hover, bufopts, "Hover text")
  remap('n', '<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
  remap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
  remap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
  remap('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts, "List workspace folders")
  remap('n', '<leader>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
  remap('n', '<leader>lrn', vim.lsp.buf.rename, bufopts, "Rename")
  remap('n', '<leader>lca', vim.lsp.buf.code_action, bufopts, "Code actions")
  vim.keymap.set('v', "<leader>lca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
    { noremap = true, silent = true, buffer = bufnr, desc = "Code actions" })
  remap('n', '<leader>lp', function() vim.lsp.buf.format { async = true } end, bufopts, "Format/Prettier file")

  require("which-key").register({
    l = {
      name = "lsp",
    },
  })
end

return M
