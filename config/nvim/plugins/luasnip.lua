local ls = require("luasnip")

vim.keymap.set({"i", "s"}, "<c-l>", function ()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, {silent = true})
