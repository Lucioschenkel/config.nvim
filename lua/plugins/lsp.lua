return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    require("conform").setup({
      formatters_by_ft = {},
    })
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local base_capabilities = vim.lsp.protocol.make_client_capabilities()
    -- Disable semantic tokens at the capability level
    base_capabilities.textDocument = base_capabilities.textDocument or {}
    base_capabilities.textDocument.semanticTokens = nil
    local cmp_capabilities = cmp_lsp.default_capabilities()
    -- Remove semantic tokens from cmp capabilities if present
    if cmp_capabilities.textDocument and cmp_capabilities.textDocument.semanticTokens then
      cmp_capabilities.textDocument.semanticTokens = nil
    end
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      base_capabilities,
      cmp_capabilities
    )
    -- Final check: ensure semantic tokens are not in the final capabilities
    if capabilities.textDocument then
      capabilities.textDocument.semanticTokens = nil
    end

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "ts_ls",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- Ensure semantic tokens are disabled (double-check)
              if client.server_capabilities.semanticTokensProvider then
                client.server_capabilities.semanticTokensProvider = nil
              end
              -- Refresh treesitter highlighting after LSP attaches
              vim.defer_fn(function()
                if vim.treesitter then
                  vim.treesitter.start(bufnr)
                end
              end, 100)
            end,
          })
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- Ensure semantic tokens are disabled (double-check)
              if client.server_capabilities.semanticTokensProvider then
                client.server_capabilities.semanticTokensProvider = nil
              end
            end,
            settings = {
              Lua = {
                format = {
                  enable = true,
                  -- Put format options here
                  -- NOTE: the value should be STRING!!
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                  },
                },
              },
            },
          })
        end,

        ["ts_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.ts_ls.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- Explicitly disable semantic tokens for TypeScript
              if client.server_capabilities.semanticTokensProvider then
                client.server_capabilities.semanticTokensProvider = nil
              end
              -- Refresh treesitter highlighting after LSP attaches
              vim.defer_fn(function()
                if vim.treesitter then
                  vim.treesitter.start(bufnr)
                end
              end, 100)
            end,
          })
        end,
      },
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
      }),
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
