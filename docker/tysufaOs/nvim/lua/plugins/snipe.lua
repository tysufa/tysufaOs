return {
  { "kungfusheep/snipe-lsp.nvim",
    event = "VeryLazy",
    dependencies = "leath-dub/snipe.nvim",
    opts = {}, 
  },
  {
    "nicholasxjy/snipe-marks.nvim",
    dependencies = { "leath-dub/snipe.nvim" },
    keys = {
      {"<leader>ml", function() require("snipe-marks").open_marks_menu() end, desc = "Find local marks"},
      {"<leader>ma", function() require("snipe-marks").open_marks_menu("all") end, desc = "Find all marks"},
    }
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      {"gb", function () require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu"}
    },
    opts = {}
  }
}
