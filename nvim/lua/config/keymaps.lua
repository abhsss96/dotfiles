-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local opts = { noremap = true, silent = true }

local function tmux_or_split_switch(wincmd, tmuxdir)
  print("hello")
  local previous_winnr = vim.fn.winnr()
  vim.api.nvim_command("silent! wincmd " .. wincmd)
  if previous_winnr == vim.fn.winnr() then
    os.execute("tmux select-pane -" .. tmuxdir)
    vim.api.nvim_command("redraw!")
  end
end

if os.getenv("TMUX") then
  vim.api.nvim_set_keymap("n", "<A-Left>", "", {
    callback = function()
      tmux_or_split_switch("h", "l")
    end,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_set_keymap("n", "<A-Down>", "", {
    callback = function()
      tmux_or_split_switch("j", "d")
    end,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_set_keymap("n", "<A-Up>", "", {
    callback = function()
      tmux_or_split_switch("k", "u")
    end,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_set_keymap("n", "<A-Right>", "", {
    callback = function()
      tmux_or_split_switch("l", "r")
    end,
    noremap = true,
    silent = true,
  })
else
  vim.api.nvim_set_keymap("n", "<A-Left>", "<C-w>h", { noremap = true })
  vim.api.nvim_set_keymap("n", "<A-Down>", "<C-w>j", { noremap = true })
  vim.api.nvim_set_keymap("n", "<A-Up>", "<C-w>k", { noremap = true })
  vim.api.nvim_set_keymap("n", "<A-Right>", "<C-w>l", { noremap = true })
end

-- Normal mode mappings
vim.api.nvim_set_keymap("n", "<S-Up>", "v<Up>", opts)
vim.api.nvim_set_keymap("n", "<S-Down>", "v<Down>", opts)
vim.api.nvim_set_keymap("n", "<S-Left>", "v<Left>", opts)
vim.api.nvim_set_keymap("n", "<S-Right>", "v<Right>", opts)

-- Visual mode mappings
vim.api.nvim_set_keymap("v", "<S-Up>", "<Up>", opts)
vim.api.nvim_set_keymap("v", "<S-Down>", "<Down>", opts)
vim.api.nvim_set_keymap("v", "<S-Left>", "<Left>", opts)
vim.api.nvim_set_keymap("v", "<S-Right>", "<Right>", opts)
vim.api.nvim_set_keymap("v", "<C-c>", "y<Esc>i", opts)
vim.api.nvim_set_keymap("v", "<C-x>", "d<Esc>i", opts)

-- Insert mode mappings
vim.api.nvim_set_keymap("i", "<S-Up>", "<Esc>v<Up>", opts)
vim.api.nvim_set_keymap("i", "<S-Down>", "<Esc>v<Down>", opts)
vim.api.nvim_set_keymap("i", "<S-Left>", "<Esc>v<Left>", opts)
vim.api.nvim_set_keymap("i", "<S-Right>", "<Esc>v<Right>", opts)
vim.api.nvim_set_keymap("i", "<C-v>", "<Esc>pi", opts)

-- All modes mapping
vim.api.nvim_set_keymap("", "<C-v>", "pi", opts)

vim.api.nvim_set_keymap("n", "<C-n>", ":enew<CR>", opts)

vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
