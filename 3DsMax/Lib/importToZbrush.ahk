#SingleInstance force


$imported_file	= %1%

$load_tool_zscript :=  "C:/Windows/Temp/_ZBRUSH_MAX_SYNC/load-exported-obj.txt"

FileDelete, %$load_tool_zscript%


$content := "[If, 1,"
$content .= "`n	[FileNameSetNext, """ $imported_file """ ]"
$content .= "`n	[IPress,Tool:Import]"
$content .= "`n	"
$content .= "`n	[IPress,Stroke:DragRect]"
$content .= "`n	[CanvasStroke,(ZObjStrokeV02n122=H43DV407YH43DV407K1XH43Dv40680H43DV409H43DV420H43DV423H43DV42AH43DV431H43DV436H43DV43FH43DV448H43DV44FH43DV45CH43DV465H43DV46FH43DV473H43DV479H43DV47EH43DV488H43DV495H43DV49DH43DV4A6H43DV4ABH43DV4B1H43DV4BBH43DV4C1H43DV4C8H43DV4CFH43DV4D7H43DV4DCH43DV4E8H43DV4F6H43DV506H43DV50DH43DV514H43DV526H43DV533H43DV548H43DV555H43DV567H43DV570H43DV57DH43DV584H43DV58AH43DV594H43DV599H43DV59DH43DV59FH43DV5A5H43DV5A7H43DV5A8H43DV5AAH43DV5ADH43DV5B1H43DV5B3H43DV5B5H43DV5BAH43DV5BDH43DV5C1H43DV5C4H43DV5C9H43DV5CCH43DV5CEH43DV5D1H43DV5D4H43DV5D6H43DV5D9H43DV5DBH43DV5DDH43DV5DEH43DV5DFH43DV5E0H43DV5E1H43DV5E2H43DV5E2H43DV5E4H43DV5E5H43DV5E6H43DV5E8H43DV5EAH43DV5EDH43DV5F0H43DV5F3H43DV5F5H43DV5F9H43DV5FDH43DV600H43DV604H43DV608H43DV60AH43DV60EH43DV611H43DV616H43DV618H43DV61AH43DV61DH43DV620H43DV622H43DV625H43DV627H43DV629H43DV62DH43DV631H43DV633H43DV638H43DV63AH43DV63DH43DV63EH43DV641H43DV642H43DV644H43DV645H43DV646H43DV648H43DV649H43DV64BH43DV64BH43DV64CH43DV64EH43DV650H43DV651H43DV651)]"
$content .= "`n	[IPress,Transform: Edit]"
$content .= "`n	[IPress,Transform:Fit]"
$content .= "`n	"
;$content .= "`n	[Note,""Edit Tool Loaded"",,1]"

$content .= "`n]"

FileAppend, %$content%, %$load_tool_zscript%

;sleep 500

;MsgBox,262144,load_tool_zscript, %$load_tool_zscript%,3

if( $zbrush_window := WinExist( "ahk_exe ZBrush.exe" ) )
{
	WinActivate, ahk_exe ZBrush.exe

	sleep 500

	Send, {Ctrl Down}{Shift Down}{Alt Down}q{Ctrl Up}{Shift Up}{Alt Up}

}