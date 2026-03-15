-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- Load editor keymaps and mason-fix after plugins are ready
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    require("config.editor").setup()
    require("config.mason-fix")
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "haml",
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "scss",
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "eruby",
  callback = function()
    vim.opt_local.foldmethod = "indent"
    -- Ensure syntax highlighting is enabled for ERB
    vim.cmd('syntax enable')
  end,
})

-- Ensure Solargraph LSP works with ERB files
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ErubyLsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "solargraph" then
      -- Solargraph should work with eruby files since we've set the filetype correctly
      -- The filetype detection in ruby.lua ensures .erb files are recognized as eruby
    end
  end,
})
