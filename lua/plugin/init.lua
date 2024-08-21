local M = {}

local filepath = vim.fn.stdpath('data') .. '/remember-colorscheme.vim'
local selected_colorscheme = nil

local function save(name)
  vim.fn.writefile({
    'colorscheme ' .. name,
    'set background=' .. vim.o.background,
  }, filepath)
end

local function load()
  if vim.fn.filereadable(filepath) == 1 then
    vim.cmd { cmd = 'source', args = { filepath } }
  end
end

function M.setup(opts)
  if opts.filepath then
    filepath = opts.filepath
  end

  vim.api.nvim_create_autocmd({ 'colorScheme' }, {
    pattern = { '*' },
    callback = function(args)
      save(args.match)
      selected_colorscheme = args.match
    end,
  })

  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = { 'background' },
    callback = function()
      if selected_colorscheme then
        save(selected_colorscheme)
      end
    end,
  })

  load()
end

return M
