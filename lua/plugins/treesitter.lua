return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter").setup {
      auto_install = true
    }
  end
}
