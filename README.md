# ry

_A Lua based vim-like terminal editor in a Go host_

## getting

```
go get github.com/kiasaki/ry
```

## building

```
make
```

## features

- vim-like modal editing
- major mode and multiple minor modes
- lua scripting

TODO

- window splits
- many color schemes
- syntax highlighting
- search mode
- quick jump mode
- built-in linter plugin
- built-in fuzzy file finder plugin
- built-in directory browser plugin
- run shell commands
- central plugin repository

**normal mode**

- <kbd>h</kbd> `move_left`
- <kbd>j</kbd> `move_down`
- <kbd>k</kbd> `move_up`
- <kbd>l</kbd> `move_right`
- <kbd>g g</kbd> `move_start`
- <kbd>G</kbd> `move_end`
- <kbd>0</kbd> `move_line_start`
- <kbd>$</kbd> `move_line_end`
- <kbd>C-u</kbd> `move_jump_up`
- <kbd>C-d</kbd> `move_jump_down`
- <kbd>z z</kbd> `center`
- <kbd>x</kbd> `delete_char`
- <kbd>d d</kbd> `delete_line`
- <kbd>i</kbd> `enter_insert_mode`
- <kbd>:</kbd> `enter_command_mode`
- <kbd>a</kbd> `move_right, enter_insert_mode`
- <kbd>A</kbd> `move_line_end, enter_insert_mode`
- <kbd>o</kbd> `insert_newline_down, enter_insert_mode`
- <kbd>O</kbd> `insert_newline_up, enter_insert_mode`

**insert mode**

- <kbd>ESC</kbd> `enter_normal_mode`
- <kbd>RET</kbd> `insert_return`
- <kbd>SPC</kbd> `insert_space`
- <kbd>TAB</kbd> `insert_tab`
- <kbd>BAK2</kbd> `move_left, delete_char`
- <kbd>DEL</kbd> `delete_char`

**command mode**

...

## license

MIT. See `LICENSE` file.

