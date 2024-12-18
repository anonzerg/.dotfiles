vim.keymap.set("t", "<esc>", "<c-\\><c-n>")

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}


local function create_floating_win(opts)
  opts = opts or {}

  local width = opts.width or math.floor(vim.o.columns * 0.5)
  local height = opts.height or math.floor(vim.o.lines * 0.5)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(flase, true)
  end

  local win_config = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    focusable = true,
    style = "minimal",
    border = "single",
  }


  local win = vim.api.nvim_open_win(buf, true, win_config)

  return {buf = buf, win = win}
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_win {buf = state.floating.buf}
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      vim.api.nvim_win_set_option(state.floating.win, "winhighlight", "NormalFloat:CustomFloat")
      vim.api.nvim_set_hl(0, "CustomFloat", {bg = "#14161B"})
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("FloaTerminal", toggle_terminal, {})
vim.keymap.set({"n", "t"}, "<leader>t", toggle_terminal)


