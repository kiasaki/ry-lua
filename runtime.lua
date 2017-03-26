local s = style("green,red,bold")

local next_key = screen_next_key()
while true do
  screen_write(s, 1, 1, "Hello world!")
  screen_show()
  next_key = screen_next_key()
end
