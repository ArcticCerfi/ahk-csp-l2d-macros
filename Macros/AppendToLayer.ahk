#Requires AutoHotkey v2.0
#Include "..\CSPLayerWalker.ahk"
#SingleInstance Force

;; This macro appends a user-defined string to the end of the currently selected layer name.

walker := CSPLayerWalker()

Suffix := ""
if A_Args.Length > 0
    Suffix := A_Args[1]

AppendToLayer(name, w) {
    newName := name . Suffix
    w.RenameCurrentLayer(newName)
    return "stop"
}

walker.WalkLayers(AppendToLayer)