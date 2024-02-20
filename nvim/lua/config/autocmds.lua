-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
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
  pattern = "erb",
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})
