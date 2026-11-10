#Requires AutoHotkey v2.0
#Include "..\CSPLayerWalker.ahk"
#SingleInstance Force

;; valid Live2D layer names must start with a letter or underscore, and can contain letters, numbers, and underscores, with a maximum length of 63 characters.
;; Go to the top of your file or layer group and make sure all child groups are expanded.
;; This macro will stop when it hits an invalid layer OR when it hits an end marker.

walker := CSPLayerWalker()
layerMap := Map()

;; If a regex is passed as an argument, it will be used instead of the default Live2D layer name validation regex.
validationRegex := "^[a-zA-Z_][a-zA-Z0-9_]{0,62}$"
if A_Args.Length > 0
    validationRegex := A_Args[1]

validateLayerName(name, w) {
    errorMsg := ""
    
    if !RegExMatch(name, validationRegex)
        errorMsg := "Invalid layer name: " . name
    else if layerMap.Has(name)
        errorMsg := "Duplicate layer name: " . name

    if (errorMsg != "") {
        w.CancelRename()
        MsgBox(errorMsg)
        return "stop"
    }

    layerMap[name] := true
    w.CancelRename()
}

walker.WalkLayers(validateLayerName)