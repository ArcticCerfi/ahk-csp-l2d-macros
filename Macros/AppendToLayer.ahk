#Requires AutoHotkey v2.0
#Include "..\CSPLayerWalker.ahk"
#SingleInstance Force

;; This macro appends a user-defined string to the end of the currently selected layer name.

walker := CSPLayerWalker()

if A_Args.Length == 0 {
    MsgBox "Please provide both a String to append as a command line argument."
    return
}
Suffix := A_Args[1]
    

AppendToLayer(name, w) {
    newName := name . Suffix
    w.RenameCurrentLayer(newName)
    return "stop" ; Stop walking after appending to the first layer
}

walker.WalkLayers(AppendToLayer)