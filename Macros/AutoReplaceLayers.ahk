#Requires AutoHotkey v2.0

#Include "..\CSPLayerWalker.ahk"
#SingleInstance Force

;; This macro automatically changes layer names according to a user-defined regex pattern and replacement string.

walker := CSPLayerWalker()

if A_Args.Length < 2 {
    MsgBox "Please provide both a search regex and a replacement string as command line arguments."
    return
}
SearchRegex := A_Args[1]
ReplacementString := A_Args[2]

ReplaceInLayer(name, w) {
    newName := RegExReplace(name, SearchRegex, ReplacementString)
    w.RenameCurrentLayer(newName)
}

walker.WalkLayers(ReplaceInLayer)