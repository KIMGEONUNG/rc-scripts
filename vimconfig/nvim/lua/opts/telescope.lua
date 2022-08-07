
local previewers = require('telescope.previewers')
local bad_extentions = { '.*%.csv', '.*%.json'} 
local size_max = 100000
local bad_files = function(filepath)
  for _, v in ipairs(bad_extentions) do
    if filepath:match(v) then
      return true
    end
  end
  return false
end

-- Telescop previewer freezes when attempting to preview large files.
-- 'new_maker' excludes the files having large size or specific file extension.
local custom_previewer_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  stat = vim.loop.fs_stat(filepath)

  if not stat then return end
  if stat.size > size_max then return end
  if bad_files(filepath) then return end
  previewers.buffer_previewer_maker(filepath, bufnr, opts)
end

require('telescope').setup{
    defaults = {
        buffer_previewer_maker = custom_previewer_maker,
        preview = {
        },
        file_ignore_patterns = {'%.pyc', '.git/*', '__pycache__/*',
            '%.jpeg', '%.jpg', '%.JPEG', '%.png', '%.gif', '%.dat',
            '%.pkl', '%.ckpt', '%.pickle', 'events.*', '%.tfrecords',
            '%.xyzn', '%.xyz', '%.obj', '%.ply'
        }
    },
    pickers = {
        find_files = {
            theme = "dropdown",
        }
    }
}

vim.cmd([[
    " Find files using Telescope command-line sugar.
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    " nnoremap <leader>ff :lua require('telescope.builtin').find_files{previewer=true}<cr>
    nnoremap <leader>fg :Telescope live_grep<cr>
    nnoremap <leader>fb :Telescope buffers<cr>
    nnoremap <leader>fh :Telescope help_tags<cr>
]])