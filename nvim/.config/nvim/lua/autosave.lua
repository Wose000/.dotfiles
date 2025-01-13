local function create_new_split_and_return_bufnr()
  vim.cmd 'vnew'
  return vim.api.nvim_get_current_buf()
end

local bufnr = create_new_split_and_return_bufnr()

local gradlew = 'gradlew'
local file_path = vim.fn.getcwd() .. '/' .. gradlew

if vim.fn.filereadable(file_path) == 1 then
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('Wow', { clear = true }),
    pattern = '*.java',
    callback = function()
      -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'hello', 'world' })
      local file_name = vim.api.nvim_buf_get_name(0)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'output of: ' .. file_name })
      vim.fn.jobstart({ './gradlew', 'build' }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
          end
        end,
      })
    end,
  })
else
  print 'File doesnt exist in cwd'
end
