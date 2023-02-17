#SingleInstance force


global $export_dir	:= "C:/Windows/Temp/_ZBRUSH_MAX_SYNC"


/**
 */
writeImportScript()
{
	$import_zscript	:= $export_dir "/importToolsToZbrush.txt"
	$files_obj	:= []
	$import_tools	:= ""
	$append_subtools	:= ""
	$rename_subtools	:= ""

	$header	:= "[If, 1,`n"
	$new_document	:= "`n	[IKeyPress, 78,[IPress, Document:New Document]]"
	$reset_tools	:= "`n	[IKeyPress, ""1"",[IReset, 3]]"
	;$footer	.= "`n]"
	$footer	.= "`n`n	[IShow,Tool]`n	[IClick, Tool:SubTool, 1]`n`n]" ; DEVELOPMENT


	Loop, Files, %$export_dir%\*.obj
		$files_obj.push( RegExReplace( A_LoopFileFullPath, "\\", "/") )

	$subtool_names	:= "`n	[VarDef, $subtool_names( " $files_obj.length() " ) ]`n"

	For $index, $file_path in $files_obj
	{
		$tool_idnex	:= $index - 1
		$tool_name	:= "tool_"	$tool_idnex
		$tool_name_full	:= "tool_name_"	$tool_idnex


		$import_tools .= "`n	"
		$import_tools .= "`n	[IPress,Tool:SimpleBrush]"
		$import_tools .= "`n	[FileNameSetNext, " $file_path " ]"
		$import_tools .= "`n	[IPress, Tool:Import]"
		$import_tools .= "`n	[VarSet, " $tool_name ",	[IGetTitle, Tool:Current Tool,0]]"
		;$import_tools .= "`n	[VarSet, " $tool_name_full ",	[IGetTitle, Tool:Current Tool]]"
		$import_tools .= "`n	[VarSet, $subtool_names(" $tool_idnex "),	[IGetTitle, Tool:Current Tool]]"

		if( $tool_idnex > 0 )
		{
			$append_subtools .= "`n	"
			$append_subtools .= "`n	[IPress,	Tool:SubTool:Append]"
			$append_subtools .= "`n	[IPress,	[StrMerge, ""PopUp:"", " $tool_name "]]"
			;$append_subtools .= "`n	[ToolSetPath,	" $tool_idnex ", " $tool_name_full "]"
		}

	}

	$load_first_tool .= "`n	"
	$load_first_tool .= "`n	[IPress, [StrMerge, ""Tool:"", tool_0] ]"
	$load_first_tool .= "`n	[IPress, Stroke:DragRect]"
	;$load_first_tool .= "`n	[CanvasStroke, (ZObjStrokeV02n2=H41EV434H41EV434)]"
	$load_first_tool .= "`n	[CanvasStroke,(ZObjStrokeV02n10=H126V47DYH126V47DK1Xh1267Fv47C80H126V47EH126V47FH126V480H126V481H126V482H126V483H126V483)]"
	$load_first_tool .= "`n	[IPress, Transform:Edit]"
	$load_first_tool .= "`n	[IPress, Transform:Fit]"


	$rename_subtools .= "`n`n	[Loop, [VarSize, $subtool_names],`n"
	$rename_subtools .= "`n		[SubToolSelect, 0]`n"
	$rename_subtools .= "`n		[ToolSetPath,, $subtool_names(i) ]`n"
	$rename_subtools .= "`n		[Loop, [SubToolGetCount] - 1,[IPress,Tool:SubTool:MoveDown] ]`n"
	$rename_subtools .= "`n	, i]"



	FileDelete, %$import_zscript%

	FileAppend, %$header%, %$import_zscript%

	FileAppend, %$subtool_names%,	%$import_zscript%

	FileAppend, %$new_document%,	%$import_zscript%
	FileAppend, %$reset_tools%,	%$import_zscript%

	FileAppend, %$import_tools%,	%$import_zscript%
	FileAppend, %$load_first_tool%,	%$import_zscript%
	FileAppend, %$append_subtools%,	%$import_zscript%

	FileAppend, %$rename_subtools%,	%$import_zscript%

	FileAppend, %$footer%,	%$import_zscript%

}


/**
 */
executeCommandInZbrush()
{
	if( $zbrush_window	:= WinExist( "ahk_exe ZBrush.exe" ) )
	{
		WinActivate, ahk_exe ZBrush.exe

		sleep 500

		/*
			Execute command "~VIL-PLUGINS:MaxZbrushSync:Max to Zbrush" in "../../Zbrush/MaxZbrushSync.txt"
		*/
		Send, {Ctrl Down}{Shift Down}{Alt Down}q{Ctrl Up}{Shift Up}{Alt Up}
	}
}

/** EXECUTE
  *
  */
writeImportScript()

executeCommandInZbrush()
