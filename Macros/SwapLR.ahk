#Requires AutoHotkey v2.0
#Include "..\CSPLayerWalker.ahk"
#SingleInstance Force

;; This macro swaps the suffixes "_L" and "_R" in layer names. It also swaps interior occurrences of "_L_" and "_R_". 
;; For example, "arm_L" becomes "arm_R", and "hand_R" becomes "hand_L".

walker := CSPLayerWalker()

SwapLR(name, w) {
    newName := name

    ; interior Swaps
    newName := StrReplace(newName, "_L_", "_TEMP_")
    newName := StrReplace(newName, "_R_", "_L_")
    newName := StrReplace(newName, "_TEMP_", "_R_")

    ; Trailing Swaps
    newName := RegExReplace(newName, "_L$", "_TEMP")
    newName := RegExReplace(newName, "_R$", "_L")
    newName := RegExReplace(newName, "_TEMP$", "_R")
    
    w.RenameCurrentLayer(newName)
}

walker.WalkLayers(SwapLR)