return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- TODO:
  opts = {
  },
  keys = {
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
  },
}
