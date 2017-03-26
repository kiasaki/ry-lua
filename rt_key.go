package main

import (
	lua "github.com/Shopify/go-lua"
	"github.com/gdamore/tcell"
)

func pushKeyFromEvent(l *lua.State, ev *tcell.EventKey) {
	ks := NewKeyStrokeFromKeyEvent(ev)
	k := NewKey("")
	k.AppendKeyStroke(ks)
	l.PushLightUserData(k)
}
