package main

import (
	"errors"
	"os"
	"unicode/utf8"

	lua "github.com/Shopify/go-lua"
)

func rtQuitEditor(l *lua.State) int {
	screen.Fini()
	os.Exit(0)
	return 0
}

func rtFatal(l *lua.State) int {
	fatal(errors.New(lua.CheckString(l, 1)))
	return 0
}

func rtPadLeft(l *lua.State) int {
	str := lua.CheckString(l, 1)
	length := lua.CheckInteger(l, 2)
	padding := lua.CheckString(l, 3)[0]
	for utf8.RuneCountInString(str) < length {
		str = string(padding) + str
	}
	l.PushString(str)
	return 1
}

func rtPadRight(l *lua.State) int {
	str := lua.CheckString(l, 1)
	length := lua.CheckInteger(l, 2)
	padding := lua.CheckString(l, 3)[0]
	for utf8.RuneCountInString(str) < length {
		str = str + string(padding)
	}
	l.PushString(str)
	return 1
}
