local lspconfig = require("lspconfig")

-- Add jinja filetypes
vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})

-- Shared on_attach & capabilities
local on_attach = function(client, bufnr)
  local buf = { buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, buf)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, buf)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, buf)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
    })
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Servers setup
local servers = {
  pyright = {},
  html = {},
  cssls = {},
  emmet_ls = {},
  jinja_lsp = {
    filetypes = { "jinja" },
    init_options = {
      templates = "./templates",
      backend = { "./" },
      lang = "python",
    },
  },
}

for name, cfg in pairs(servers) do
  cfg = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, cfg)
  lspconfig[name].setup(cfg)
end

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
})

