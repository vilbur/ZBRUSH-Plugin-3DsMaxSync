#SingleInstance force


$imported_file	= %1%


$load_tool_zscript :=  A_LineFile "/../load-exported-obj.txt"

FileDelete, %$load_tool_zscript%

$content := "[If, 1, [FileNameSetNext, """ $imported_file """ ] ]"
;$content := "[If, 1, [Note, ""load-exported-tool.txt"" ] ]"

FileAppend, %$content%, %$load_tool_zscript%

sleep 500

;MsgBox,262144,load_tool_zscript, %$load_tool_zscript%,3

if( $zbrush_window := WinExist( "ahk_exe ZBrush.exe" ) )
{
	WinActivate, ahk_exe ZBrush.exe

	sleep 500

	Send, {Ctrl Down}{Shift Down}{Alt Down}q{Ctrl Up}{Shift Up}{Alt Up}

	;sleep 500

	;SendInput, %$load_tool_zscript%




	;$old_clip=clipboard      ;save the clipboard contents
	;clipboard=%$imported_file%
	;ClipWait, 2
	;;WinActivate, Target
	;send ^v
	;;clipboard=$old_clip      ;restore the clipboard contents
	;
	;sleep 500
	;
	;RegExReplace( $imported_file, "/", "\") ;"
	;
	;Send,{Enter}

}
