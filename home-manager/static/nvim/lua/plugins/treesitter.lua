-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects", "nvim-treesitter/playground" },
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "bash",
      "c",
      "cpp",
      "diff",
      "dockerfile",
      "gitcommit",
      "gitignore",
      "go",
      "html",
      "java",
      "javascript",
      "json",
      "lua",
      "make",
      "markdown",
      "nix",
      "proto",
      "python",
      "query",
      "rust",
      "solidity",
      "toml",
      "typescript",
      "vim",
      "yaml",
    })
  end,
}
