vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      -- Disable semantic tokens to prevent conflict with treesitter highlighting
      if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ async = false, id = args.data.client_id })
      end,
    })

    -- set keymap for 'go to references' using Telescope
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references,
      { buffer = args.buf, desc = "Go to references" })
  end
})
