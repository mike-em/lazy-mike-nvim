return {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
  settings = {
    workingDirectory = { mode = "auto" }, -- Automatically locate the nearest ESLint configuration
    validate = "on",                      -- Enable validation for the specified filetypes
  },
  handlers = {
    ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
      if not result then return end
      local filtered_diagnostics = {}
      for _, diagnostic in ipairs(result.diagnostics) do
        if not diagnostic.message:find("No ESLint configuration found") then
          table.insert(filtered_diagnostics, diagnostic)
        end
      end
      result.diagnostics = filtered_diagnostics
      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end,
  },
}
