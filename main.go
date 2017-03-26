package main

import (
	"fmt"
	"os"

	lua "github.com/Shopify/go-lua"
	"github.com/Shopify/goluago"
	glgUtil "github.com/Shopify/goluago/util"
	"github.com/gdamore/tcell"
	"github.com/gdamore/tcell/encoding"
	"github.com/go-errors/errors"
)

var (
	L            *lua.State
	screen       tcell.Screen
	tabWidth     int = 2
	screenEvents chan (tcell.Event)
)

func main() {
	var err error

	L = lua.NewState()
	lua.OpenLibraries(L)
	goluago.Open(L)

	if screen, err = tcell.NewScreen(); err != nil {
		fmt.Printf("Error: %s\n", err)
		os.Exit(1)
	}
	if err = screen.Init(); err != nil {
		fmt.Printf("Error: %s\n", err)
		os.Exit(1)
	}
	encoding.Register()
	tcell.SetEncodingFallback(tcell.EncodingFallbackASCII)
	screen.SetStyle(tcell.StyleDefault.
		Foreground(tcell.ColorWhite).
		Background(tcell.ColorDefault))
	screen.Clear()
	screen.ShowCursor(-1, -1)

	// rt globals
	glgUtil.DeepPush(L, os.Args)
	L.SetGlobal("ARGS")

	// rt_util
	L.Register("quit_editor", rtQuitEditor)
	L.Register("fatal", rtFatal)
	L.Register("pad_left", rtPadLeft)
	L.Register("pad_right", rtPadRight)
	L.Register("file_read_all", rtFileReadAll)

	// rt_style
	L.Register("style", rtStyle)

	// rt_screen
	L.Register("screen_write", rtScreenWrite)
	L.Register("screen_show", rtScreenShow)
	L.Register("screen_sync", rtScreenSync)
	L.Register("screen_clear", rtScreenClear)
	L.Register("screen_size", rtScreenSize)
	L.Register("screen_quit", rtScreenQuit)
	L.Register("screen_next_key", rtScreenNextKey)

	// rt_key
	L.Register("key", rtKey)
	L.Register("key_str", rtKeyStr)
	L.Register("key_len", rtKeyLen)
	L.Register("key_append", rtKeyAppend)
	L.Register("key_matches", rtKeyMatches)
	L.Register("key_matches_part", rtKeyMatchesPart)

	defer handlePanics()

	screenEvents = make(chan tcell.Event, 20)
	go func() {
		for {
			screenEvents <- screen.PollEvent()
		}
	}()

	if err = lua.DoFile(L, "runtime.lua"); err != nil {
		fatal(err)
	}

	screen.Fini()
}

func handlePanics() {
	err := recover()
	if err != nil {
		switch err := err.(type) {
		case error:
			fatal(err)
		case string:
			fatal(errors.New(err))
		default:
			fatal(errors.New(fmt.Sprintf("Unknown panic type: %v", err)))
		}
	}
}

func fatal(err error) {
	screen.Fini()
	fmt.Fprintf(os.Stderr, "%v\n", "FATAL")
	fmt.Fprintf(os.Stderr, "%v\n", err)
	fmt.Print(errors.Wrap(err, 2).ErrorStack())
	os.Exit(1)
}
