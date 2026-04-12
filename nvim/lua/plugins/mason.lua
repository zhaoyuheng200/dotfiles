-- Tools that should not be auto-installed by Mason (e.g. not present on this system)
local optional_tools = {
  "gofumpt",
  "goimports",
  "delve",
}

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Add tools to install
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "debugpy",
        "java-debug-adapter",
        "java-test",
        "shellcheck",
        "shfmt",
        "stylua",
      })

      -- Remove optional tools so Mason won't auto-install them
      local skip = {}
      for _, name in ipairs(optional_tools) do
        skip[name] = true
      end
      opts.ensure_installed = vim.tbl_filter(function(name)
        return not skip[name]
      end, opts.ensure_installed)
    end,
  },
}
