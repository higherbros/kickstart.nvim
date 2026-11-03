-- Claude Code IDE integration (selection context, @-mentions, native diffs).
-- Run `claude` in a separate terminal pane at the same project root, then `/ide`.
return {
  'coder/claudecode.nvim',
  event = 'VeryLazy', -- start the IDE server on launch so `/ide` can find it
  opts = {
    terminal = { provider = 'none' },
  },
  keys = {
    { '<leader>a', nil, desc = '[A]I / Claude' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection' },
    { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file', ft = { 'neo-tree' } },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
