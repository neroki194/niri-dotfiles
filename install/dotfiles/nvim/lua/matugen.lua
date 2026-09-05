 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#111417',
    base01 = '#1d2024',
    base02 = '#282a2e',
    base03 = '#8c919b',
    base04 = '#c2c7d1',
    base05 = '#e1e2e7',
    base06 = '#e1e2e7',
    base07 = '#e1e2e7',
    base08 = '#ffb4ab',
    base09 = '#ecb2f9',
    base0A = '#b5c8e3',
    base0B = '#9fcaff',
    base0C = '#ecb2f9',
    base0D = '#9fcaff',
    base0E = '#b5c8e3',
    base0F = '#d2e4ff',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#e1e2e7',          bg = '#111417' })
  hi('TelescopeBorder',         { fg = '#8c919b',             bg = '#111417' })
  hi('TelescopePromptNormal',   { fg = '#e1e2e7',          bg = '#111417' })
  hi('TelescopePromptBorder',   { fg = '#8c919b',             bg = '#111417' })
  hi('TelescopePromptPrefix',   { fg = '#9fcaff',             bg = '#111417' })
  hi('TelescopePromptCounter',  { fg = '#c2c7d1',  bg = '#111417' })
  hi('TelescopePromptTitle',    { fg = '#111417',             bg = '#9fcaff' })
  hi('TelescopePreviewTitle',   { fg = '#111417',             bg = '#b5c8e3' })
  hi('TelescopeResultsTitle',   { fg = '#111417',             bg = '#ecb2f9' })
  hi('TelescopeSelection',      { fg = '#e1e2e7',          bg = '#282a2e' })
  hi('TelescopeSelectionCaret', { fg = '#9fcaff',             bg = '#282a2e' })
  hi('TelescopeMatching',       { fg = '#9fcaff',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
