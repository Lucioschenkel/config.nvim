return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      ok, configs = pcall(require, "nvim-treesitter")
    end
    if not ok then
      vim.notify("nvim-treesitter is not available", vim.log.levels.ERROR)
      return
    end
    configs.setup({
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
    })
  end,
}
