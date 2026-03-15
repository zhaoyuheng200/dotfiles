return {
  -- LSP servers (installed via mason-lspconfig)
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "docker_compose_language_service",
        "dockerls",
        "eslint",
        "gopls",
        "jdtls",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "ruff",
        "taplo",
        "ts_ls",
        "vtsls",
      },
    },
  },
  -- Non-LSP tools: formatters, linters, DAPs (installed via mason.nvim)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "delve",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "hadolint",
        "java-debug-adapter",
        "java-test",
        "js-debug-adapter",
        "markdownlint-cli2",
        "markdown-toc",
        "prettier",
        "shellcheck",
        "shfmt",
        "stylua",
      },
    },
  },
}
