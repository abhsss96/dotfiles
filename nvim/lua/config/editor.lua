-- General editor configurations
local M = {}

-- Configure general editor settings
M.setup = function()
  -- Add key mapping to yank relative file path
  vim.keymap.set('n', 'yf', function()
    local path = vim.fn.expand('%')
    vim.fn.setreg('+', path)
    vim.notify('Yanked relative path: ' .. path, vim.log.levels.INFO)
  end, { desc = 'Yank relative file path' })
end

return M 