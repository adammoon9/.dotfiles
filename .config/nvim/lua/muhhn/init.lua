local modules = {
    'muhhn.set',
    'muhhn.remap',
    'muhhn.lazy-nvim',
    'muhhn.lsp'
}

for _, m in ipairs(modules) do
    require(m)
end
