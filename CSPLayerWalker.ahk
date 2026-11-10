#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

;; BIG FAT WARNING: UI Automation is VERY fragile. The script has no way of knowing it messed something up. Use at your own risk. Don't come at me if it breaks your shit.
;; Always make a backup of your file before running any macro!! And probably give it an isolated test run first so you understand how it works.

;; The script traverses layers downwards from what is currently selected. Thus, layer groups that are collapsed will have their content skipped.
;; ALWAYS place a reachable stopMarker layer under the last layer you want to process. Otherwise it will run infinitely until killed manually.

;; While i tried to make sure the script renames layers correctly, rarely it can still skip a layer.

;; Be sure to set the correct keybinds in CSP and in the class below.

Q::ExitApp() ; Kill the script with the Q key when its running.

if (!WinActive("ahk_exe CLIPStudioPaint.exe"))
    ExitApp()



class CSPLayerWalker {
    delay := 60
    stopMarker := "END"           ; When this string is found in a layer name, the macro will stop instantly.
    keybinds := {
        selectAllTxt: "^a",
        copyTxt: "^c",
        pasteTxt: "^v",

        confirm: "{Enter}",
        cancel: "{Esc}",

        renameLayer: "{F2}",      ; Menu Commands > Layer > Change Layer Name
        nextLayer: "{PgDn}",      ; Menu Commands > Layer > Change Selected Layer > Next Layer
        deleteLayer : "{Delete}"  ; Menu Commands > Layer > Delete Layer
    }

    GetLayerName() {
        A_Clipboard := ""

        Send(this.keybinds.renameLayer)
        Sleep(this.delay)

        Send(this.keybinds.copyTxt)

        if !ClipWait(this.delay) {
            Send(this.keybinds.cancel)
            return ""
        }

        return A_Clipboard
    }

    RenameCurrentLayer(newName) {
        A_Clipboard := newName
        Sleep(this.delay)

        ; Keep hammering paste and copy until the clipboard content matches the new name. Sometimes Ctrl+V doesn't come through the first time. (Hey, if it works it works)
        Loop {
            Send(this.keybinds.pasteTxt)
            Sleep(this.delay)

            Send(this.keybinds.selectAllTxt)
            Sleep(this.delay)

            Send(this.keybinds.copyTxt)

            if(A_Clipboard == newName)
                break
            
            A_Clipboard := newName

            Sleep(this.delay + 100) ; Wait a bit longer before retrying.
        }

        Send(this.keybinds.confirm)
        Sleep(this.delay)
    }

    CancelRename() {
        Send(this.keybinds.cancel)
        Sleep(this.delay)
    }

    DeleteLayer() {
        Send(this.keybinds.deleteLayer)
        Sleep(this.delay)
    }
    
    MoveDown(amount) {
        Loop amount {
            Send(this.keybinds.nextLayer)
            Sleep(this.delay)
        }
    }

    WalkLayers(callback) {
        Loop {
            currentName := this.GetLayerName()

            if(currentName = "") {
                MsgBox("Failed to get layer name. Stopping traversal.")
                return
            }

            if(currentName = this.stopMarker) {
                this.CancelRename()
                this.DeleteLayer() ; Delete the stop marker layer. Comment this line out if you want to keep it.
                return
            }

            if(IsObject(callback)) {
                action := callback(currentName, this)
                if (action = "stop") {
                    this.CancelRename()
                    break
                }
            } else {
                this.CancelRename()
            }

            this.MoveDown(1)
        }
    }
}