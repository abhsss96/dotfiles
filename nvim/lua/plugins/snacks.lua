return {
  "folke/snacks.nvim",
  opts = {},
  keys = {
    -- Move notification history from <leader>n to <leader>N
    { "<leader>n", false },
    { "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification History" },
  },
}
