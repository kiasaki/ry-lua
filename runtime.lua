-- {{{ Globals
settings = {}
buffers = {}
keymaps = {}
root_window = nil
current_window = nil
message = "mess"
message_type = "info"

id_counter = 0
function next_id()
  id_counter = id_counter + 1
  return id_counter
end
-- }}}

-- {{{ Color schemes
styles = {
  line_number = style("yellow");
  identifier = style("");
  message_info = style("");
  message_warning = style("brightyellow");
  message_error = style("brightred");
}
function style_for(name)
  return styles[name] or style("default")
end
-- }}}

-- {{{ Window
win_type_hori = "win_type_hori"
win_type_vert = "win_type_vert"
win_type_leaf = "win_type_leaf"

function win_new(typ, a, b)
  local w
  if typ == win_type_leaf then
    w = { buffer = a; scroll_line = 1 }
  elseif typ == win_type_hori then
    w = { top = a; bottom = b }
  elseif typ == win_type_vert then
    w = { left = a; right = b }
  else
    error("win_new: given invalid type")
  end

  w.typ = typ
  w.id = next_id()
  return w
end
-- }}}

-- {{{ Buffer
function buf_new(name, path)
  return {
    id = next_id();
    name = name;
    path = path;
    modified = false;

    lines = {""};
    x = 1;
    y = 1;

    settings = {};
  }
end
-- }}}

-- {{{ Display
function display_window_leaf(win, x, y, w, h)
  local b = win.buffer
  local s = style_for("identifier")
  local sln = style_for("line_number")

  local gutter_w = #tostring(#b.lines)+1

  for line = win.scroll_line, #b.lines, 1 do
    screen_write(sln, x, y+line-1, pad_left(tostring(line), gutter_w, " "))
    screen_write(s, x+gutter_w, y+line-1, b.lines[line])
  end
end

function display_window(win, x, y, w, h)
  if win.typ == win_type_leaf then
    display_window_leaf(win, x, y, w, h)
  else
    error("don't know how to display window")
  end
end

function display_bottom_bar(y, width)
  local s = style_for("message_"..message_type)
  screen_write(s, 0, y, message)
end

function display()
  local width, height = screen_size()

  display_window(root_window, 0, 0, width, height-1)
  display_bottom_bar(height-1, width)

  screen_show()
end
-- }}}

-- {{{ Main loop
function main()
  local scratch_buffer = buf_new("*scratch*")
  table.insert(buffers, scratch_buffer)
  root_window = win_new(win_type_leaf, scratch_buffer)
  current_window = root_window

  local next_key = screen_next_key()
  while true do
    if next_key then
      ls = current_window.buffer.lines
      ls[1] = ls[1]..key_str(next_key)
    end
    display()
    next_key = screen_next_key()
  end
end

main()
-- }}}
