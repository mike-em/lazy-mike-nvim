local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end
M.capabilities.textDocument.completion.completionItem.snippetSupport = false
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
  vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = {
      spacing = 2,
      prefix = '■',
      -- Only show virtual text for non-eslint diagnostics
      severity = { min = vim.diagnostic.severity.HINT }, -- optional
      -- Conditional display
      format = function(diagnostic)
        --[[ if diagnostic.source == "eslint" then ]]
        --[[ return nil -- return nil disables the virtual text entirely ]]
        --[[ end ]]
        return diagnostic.message
      end,
    },
    signs = {
      severity = {
        Error = { text = "✗", texthl = "DiagnosticSignError" },
        Warn  = { text = "!", texthl = "DiagnosticSignWarn" },
        Hint  = { text = "•", texthl = "DiagnosticSignHint" },
        Info  = { text = "i", texthl = "DiagnosticSignInfo" },
      },
    },
    update_in_insert = false,
    underline = false,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "if_many",
      header = "",
      prefix = "",
    },
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

local function lsp_highlight_document(client, bufnr)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end
  illuminate.on_attach(client, bufnr)
end

local function trim_empty_lines(contents)
  if type(contents) == "string" then
    -- Remove multiple empty lines in a string
    return contents:gsub("\n%s*\n", "\n")
  elseif type(contents) == "table" then
    -- Filter out empty or whitespace-only lines in a table
    return vim.tbl_filter(function(line)
      return line:match("%S")
    end, contents)
  else
    -- fallback, return as-is
    return contents
  end
end

function _G.hover()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  -- Get cursor position (0-indexed line and character)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    position = { line = row - 1, character = col }
  }

  vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result, ctx, _)
    if err then return end
    local contents = result and result.contents
    if not contents or (type(contents) == "table" and vim.tbl_isempty(contents)) then return end
    contents = vim.lsp.util.convert_input_to_markdown_lines(contents)
    contents = trim_empty_lines(contents)
    if vim.tbl_isempty(contents) then return end
    vim.lsp.util.open_floating_preview(contents, "markdown", { border = "rounded" })
  end)
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>Telescope lsp_declarations<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua _G.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = false })' ]])
  vim.cmd([[ command! CA lua vim.lsp.buf.code_action() ]])
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-f>", "<cmd>Format<cr>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-a>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client, bufnr)

  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
    require("lsp-inlayhints").on_attach(client, bufnr)
  end

  if client.name == "zig" then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "jdt.ls" then
    vim.lsp.codelens.refresh()
  end
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.svelte", "*.css", "*.scss" },
  callback = function()
    vim.cmd("FormatWrite")
  end
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.json" },
  callback = function()
    vim.cmd("Format")
  end
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*.lua', '*.go', '*.zig' },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_set_keymap('n', '<leader>f',
  [[<cmd>lua vim.fn.system('npx eslint --fix "' .. vim.fn.expand('%:p') .. '"') vim.cmd('edit')<CR>]],
  { noremap = true, silent = true })

return M
