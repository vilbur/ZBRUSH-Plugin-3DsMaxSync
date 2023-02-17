#SingleInstance force


global $export_dir	:= "C:/Windows/Temp/_ZBRUSH_MAX_SYNC"


/**
 */
writeImportScript()
{

	$import_zscript	:= $export_dir "/importToolsToZbrush.txt"
	$dates	:= $export_dir "/dates.txt"
	$files_obj	:= []

	FileDelete, %$test%
	
	/*
		1) Get .obj and .mtl files
		2) Remove counter prefix E.G.: "01-_-fooFile.obj" >>> "fooFile.obj"
	*/ 
	Loop, Files, %$export_dir%\*.*
	{
		if( A_LoopFileExt == "obj" ||  A_LoopFileExt == "mtl" )
		{
			$nosuffix_path :=  A_LoopFileDir "/" RegExReplace( A_LoopFileName, "\d+\-_\-", "") ;; 

			FileMove, %A_LoopFileFullPath%, %$nosuffix_path%
			
			if( A_LoopFileExt == "obj" )
				$files_obj.push( RegExReplace( $nosuffix_path, "\\", "/") )
		}
	}

	$tools_count := $files_obj.length()

	$header	:= "[If, 1,`n"
	$new_document	:= "`n	[IKeyPress, 78,[IPress, Document:New Document]]"
	$reset_tools	:= "`n	[IKeyPress, ""1"",[IReset, 3]]`n"
	$footer	:= "`n]"


	$vardef	:= "`n	[VarDef, $tool_paths("	$tools_count ") ]"
	$vardef	.= "`n	[VarDef, $tool_names("	$tools_count ") ]"
	$vardef	.= "`n	[VarDef, $subt_names("	$tools_count ") ]`n"


	$tool_paths := ""
	For $index, $file_path in $files_obj
		$tool_paths .= "`n	[VarSet, $tool_paths(" $index - 1 "),	""" $file_path """ ]"


	$import_tools .= "`n`n	/* IMPORT TOOLS */"
	$import_tools .= "`n	[Loop, " $tools_count ","
	$import_tools .= "`n		[IPress,Tool:SimpleBrush]"
	$import_tools .= "`n		[FileNameSetNext, $tool_paths(i) ]"
	$import_tools .= "`n		[IPress, Tool:Import]"
	$import_tools .= "`n		[VarSet, $tool_names(i),	[IGetTitle, Tool:Current Tool, 0]]"
	$import_tools .= "`n		[VarSet, $subt_names(i),	[IGetTitle, Tool:Current Tool  ]]"
	$import_tools .= "`n	, i]"


	$load_first_tool .= "`n`n	/* LOAD FIRST TOOL */"
	$load_first_tool .= "`n	[IPress, [StrMerge, ""Tool:"", $tool_names(0)] ]"
	$load_first_tool .= "`n	[IPress, Stroke:DragRect]"
	;$load_first_tool .= "`n	[CanvasStroke, (ZObjStrokeV02n2=H41EV434H41EV434)]"
	$load_first_tool .= "`n	[CanvasStroke,(ZObjStrokeV02n10=H126V47DYH126V47DK1Xh1267Fv47C80H126V47EH126V47FH126V480H126V481H126V482H126V483H126V483)]"
	$load_first_tool .= "`n	[IPress, Transform:Edit]"
	$load_first_tool .= "`n	[IPress, Transform:Fit]"


	if( $tools_count > 1 )
	{
		$append_subtools .= "`n`n	/* APPEND SUBTOOLS */"
		$append_subtools .= "`n	[Loop, " $tools_count - 1 ","
		$append_subtools .= "`n		[IPress,	Tool:SubTool:Append]"
		$append_subtools .= "`n		[IPress,	[StrMerge, ""PopUp:"", $tool_names(i + 1)]]"
		$append_subtools .= "`n	, i]"
	
	
		$rename_subtools .= "`n`n	/* RENAME SUBTOOLS */"
		$rename_subtools .= "`n	[Loop, " $tools_count ","
		$rename_subtools .= "`n		[SubToolSelect, 0]"
		$rename_subtools .= "`n		[ToolSetPath,, $tool_names(i) ]"
		$rename_subtools .= "`n		[Loop, [SubToolGetCount] - 1,[IPress,Tool:SubTool:MoveDown] ]"
		$rename_subtools .= "`n	, i]"
		
		$footer	:= "`n`n	[IShow,Tool]`n	[IClick, Tool:SubTool, 1]`n`n]"
	}


	FileDelete, %$import_zscript%
	

	FileAppend, %$header%,	%$import_zscript%
		
	FileAppend, %$new_document%,	%$import_zscript%
		
	FileAppend, %$reset_tools%,	%$import_zscript%
		
	FileAppend, %$vardef%,	%$import_zscript%
		
	FileAppend, %$tool_paths%,	%$import_zscript%
		
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
