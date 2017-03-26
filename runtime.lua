-- {{{ Globals
json = require("goluago/encoding/json")
strings = require("goluago/strings")

settings = {}
buffers = {}
keymaps = {}
root_window = nil
current_window = nil
message = ""
message_type = "info"

id_counter = 0
function next_id()
  id_counter = id_counter + 1
  return id_counter
end

function debug_value(value)
  screen_quit()
  print(json.marshal(value))
  os.exit(1)
end
-- }}}

-- {{{ Color schemes
styles = {
  line_number = style("yellow");
  status_line = style("black,white");
  cursor = style("black,white");
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

function buffer_load(path)
  local path_parts = strings.split(path, "/")
  local b = buf_new(path_parts[#path_parts], path)

  b.lines = strings.split(file_read_all(path), "\n")

  table.insert(buffers, b)
  return b.id
end
-- }}}

-- {{{ Display
function display_window_leaf(win, x, y, w, h)
  local b = win.buffer
  local s = style_for("identifier")
  local sln = style_for("line_number")

  local gutter_w = #tostring(#b.lines)+1

  -- contents
  for line = win.scroll_line, #b.lines, 1 do
    screen_write(sln, x, y+line-1, pad_left(tostring(line), gutter_w-1, " "))
    screen_write(s, x+gutter_w, y+line-1, b.lines[line])

    -- write cursor
    if line == b.y then
      local sc = style_for("cursor")
      local ch = string.sub(b.lines[line], b.x, b.x)
      screen_write(sc, x+gutter_w+b.x-1, y+line-1, ch)
    end

    if line >= h-1 then -- (-1) for status line
      break
    end
  end

  -- status line
  local ssl = style_for("status_line")
  local text = " "..b.name.." "..b.x..":"..b.y.."/"..#b.lines
  screen_write(ssl, x, y+h-1, pad_right(text, w, " "))
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
  -- Load files in ARGS
  for i = 2, #ARGS, 1 do
    buffer_load(ARGS[i])
  end
  if #buffers == 0 then
    local scratch_buffer = buf_new("*scratch*")
    table.insert(buffers, scratch_buffer)
  end

  -- Show first buffer in root window
  root_window = win_new(win_type_leaf, buffers[1])
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
