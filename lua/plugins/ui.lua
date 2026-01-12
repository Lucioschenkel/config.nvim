local set_theme = function (theme)
  theme = theme or "midnight"

  vim.cmd.colorscheme(theme)

  -- this makes the background transparent
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end


return {
  {
    'dasupradyumna/midnight.nvim', lazy = false, priority = 1000,
    config = function ()
      set_theme("midnight")
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = "palenight"
    }
  },
  {
    "stevearc/oil.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("oil").setup()

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })
      vim.keymap.set('n', '<leader>e', "<CMD>Oil<CR>")
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
