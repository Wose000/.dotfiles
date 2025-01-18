local function get_hostname()
  -- Execute the `hostname` command and capture the output
  local handle = io.popen 'hostname'
  if handle ~= nil then
    local hostname = handle:read('*a'):gsub('%s+', '') -- Remove trailing newline
    handle:close()
    return hostname
  end
  print 'Could not find host name'
end

local function get_vault_path()
  if get_hostname() == 'woselaptop' then
    return '/home/wose/m/doc/note/'
  else
    return '/home/wose/m/doc/note/'
  end
end

return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    'BufReadPre path/to/my-vault/*.md',
    'BufNewFile path/to/my-vault/*.md',
  },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter',
  },
  keys = {
    { '<leader>nd', ':ObsidianToday<cr>', desc = 'obsidian [d]aily' },
    { '<leader>nt', ':ObsidianToday 1<cr>', desc = 'obsidian [t]omorrow' },
    { '<leader>ny', ':ObsidianToday -1<cr>', desc = 'obsidian [y]esterday' },
    { '<leader>nb', ':ObsidianBacklinks<cr>', desc = 'obsidian [b]acklinks' },
    { '<leader>nl', ':ObsidianLink<cr>', desc = 'obsidian [l]ink selection' },
    { '<leader>nf', ':ObsidianFollowLink<cr>', desc = 'obsidian [f]ollow link' },
    { '<leader>nn', ':ObsidianNew<cr>', desc = 'obsidian [n]ew' },
    { '<leader>ns', ':ObsidianSearch<cr>', desc = 'obsidian [s]earch' },
    { '<leader>no', ':ObsidianQuickSwitch<cr>', desc = 'obsidian [o]pen quickswitch' },
    { '<leader>nO', ':ObsidianOpen<cr>', desc = 'obsidian [O]pen in app' },
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = get_vault_path(),
      },
    },
    follow_url_func = function(url)
      vim.fn.jobstart { 'xdg-open', url }
    end,
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'Life/Journal',
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = '%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily-notes' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = 'telescope.nvim',
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = '<C-x>',
        -- Insert a link to the selected note.
        insert_link = '<C-l>',
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = '<C-x>',
        -- Insert a tag at the current location.
        insert_tag = '<C-l>',
      },
    },
  },
}
