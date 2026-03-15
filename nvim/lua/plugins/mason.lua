return {
  -- Only tools NOT already installed by LazyVim lang extras
  -- LazyVim extras handle: hadolint, goimports, gofumpt, golangci-lint,
  --   delve, markdownlint-cli2, markdown-toc, js-debug-adapter, prettier
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "debugpy",
        "java-debug-adapter",
        "java-test",
        "shellcheck",
        "shfmt",
        "stylua",
      },
    },
  },
}
