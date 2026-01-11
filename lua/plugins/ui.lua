return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup {
        transparent = true,
        styles = {
          siderbar = "transparent",
          floats = "transparent"
        },
      }

      vim.cmd.colorscheme "tokyonight"
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
}
