vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })

if vim.g.vscode then
  vim.keymap.set("n", "%", function() require("vscode-neovim").action "editor.action.jumpToBracket" end)
end
