-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- Only show winbar for real file buffers, not dashboard/neo-tree/etc
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    local bt = vim.bo.buftype
    local ft = vim.bo.filetype
    local excluded = { "dashboard", "neo-tree", "lazy", "mason", "snacks_dashboard", "help", "nofile" }
    for _, v in ipairs(excluded) do
      if ft == v or bt == v then
        vim.opt_local.winbar = ""
        return
      end
    end
    if bt == "" and vim.bo.buflisted then
      vim.opt_local.winbar = "%=%m %f"
    else
      vim.opt_local.winbar = ""
    end
  end,
})
