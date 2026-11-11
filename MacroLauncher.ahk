#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

#HotIf WinActive("ahk_exe ClipStudioPaint.exe")

!n::Run(A_ScriptDir "\Macros\AppendToLayer.ahk" " _LINE")       ; Mark this layer as a Backfill.
!m::Run(A_ScriptDir "\Macros\AppendToLayer.ahk" ' " #MIR"')     ; Mark this layer as  "To-Mirror".

#HotIf