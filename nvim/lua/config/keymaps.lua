-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local opts = { noremap = true, silent = true }

local function tmux_or_split_switch(wincmd, tmuxdir)
  local previous_winnr = vim.fn.winnr()
  vim.api.nvim_command("silent! wincmd " .. wincmd)

  -- Check if the window number did not change, indicating that the window split failed
  if previous_winnr == vim.fn.winnr() then
    local tmux_command = "tmux select-pane -" .. tmuxdir
    local status = os.execute(tmux_command)

    if status == 0 then
      vim.api.nvim_command("redraw!")
      return true -- Tmux command was successful
    else
      return false -- Tmux command failed
    end
  end

  return true -- Window split was successful
end

if os.getenv("TMUX") then
  vim.api.nvim_set_keymap("n", "<A-Left>", "", {
    callback = function()
      tmux_or_split_switch("h", "L")
    end,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_set_keymap("n", "<A-Down>", "", {
    callback = function()
      tmux_or_split_switch("j", "D")
    end,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_set_keymap("n", "<A-Up>", "", {
    callback = function()
      tmux_or_split_switch("k", "U")
    end,
    noremap = true,
    silent = true,
  })
  vim.api.nvim_set_keymap("n", "<A-Right>", "", {
    callback = function()
      tmux_or_split_switch("l", "R")
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

-- Ctrl+a to mark all text
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

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
vim.api.nvim_set_keymap("", "<D-v>", "pi", opts)

vim.api.nvim_set_keymap("n", "<D-n>", ":enew<CR>", opts)

vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})

-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>j", "<cmd>Telekasten panel<CR>")

-- Most used functions
vim.keymap.set("n", "<leader>jf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>jg", "<cmd>Telekasten search_notes<CR>")
vim.keymap.set("n", "<leader>jd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>jz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>jn", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>jc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>jb", "<cmd>Telekasten show_backlinks<CR>")
vim.keymap.set("n", "<leader>jI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")

vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open Obsidian" })
vim.keymap.set("n", "<leader>od", "<cmd>ObsidianToday<CR>", { desc = "Open today's note" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Create new note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search Obsidian notes" })
