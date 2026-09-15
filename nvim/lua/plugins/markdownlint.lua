-- markdownlint-cli2 only looks for config files in its working directory; it
-- never searches parent directories. So a config in $HOME would be ignored
-- whenever Neovim's cwd is a project. Point the linter at one explicitly to
-- get a machine-wide default instead.
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = function(_, opts)
    opts.linters = opts.linters or {}
    opts.linters["markdownlint-cli2"] = {
      -- Base config; a repo-local .markdownlint.jsonc still takes precedence.
      -- Must be an absolute path: cli2 does not expand a leading "~" here.
      args = { "--config", vim.fn.stdpath("config") .. "/markdownlint.jsonc", "-" },
    }
  end,
}
