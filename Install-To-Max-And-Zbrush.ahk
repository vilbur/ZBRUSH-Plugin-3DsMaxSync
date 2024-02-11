#SingleInstance force

/** -------------------------------------------
  *
  *    INSTAll to 3Ds Max and Zbrush
  *
  * -------------------------------------------
  */

$filename := "MaxToZbrushSync.mcr"

$MAX_VERSION := "2023"

global $PATH_MAX_SCRIPT := "C:\\Users\\%username%\\AppData\\Local\\Autodesk\\3dsMax\\" $MAX_VERSION " - 64bit\\ENU\\scripts\\MAXSCRIPT-viltools3\\VilTools\\rollouts-Tools\\rollout-EXPORT\\rollouts-ExportTo\\rollout-ZBRUSH"

/** CREATE HARDLINKS TOS ZBRUSH
 */
createHardlink( $path_source, $path_link )
{
	$is_folder := InStr( FileExist($path_source), "D" ) != 0

	$file_or_folder	:= $is_folder ? "/d" : ""
	;MsgBox,262144,path_source, %$path_source%
	;MsgBox,262144,path_link, %$path_link%
	;MsgBox,262144,is_folder, %$is_folder%

	$mklink	:= "mklink " $file_or_folder " """ $path_link """ """ $path_source """"
	;MsgBox,262144,mklink, %$mklink%

	RunWait %comspec% /c %$mklink%,,Hide
}

/**
  *
  */
InstallToMaxAndZbrush()
{
	$path_max_script	:= RegExReplace( $path_max_script, "%username%", A_UserName ) ;"

	If FileExist( $path_max_script )
	{
		;$path_source =%  A_WorkingDir 	\3DsMax\

		Loop Files, %A_WorkingDir%\3DsMax\*, DF
		{
			$path_link := $path_max_script "\\" A_LoopFileName

			createHardlink( A_LoopFileFullPath, $path_link )


			;if InStr( FileExist($path_source), "D" ) != 0
			;	FileCopyDir,	%A_LoopFileFullPath%, %$path_target%, 1
			;
			;else
			;	FileCopy,	%A_LoopFileFullPath%, %$path_target%, 1

			;MsgBox,262144,path_target, %$path_target%
			;MsgBox,262144,A_LoopFileFullPath, %A_LoopFileFullPath%
		}

	}
	else
		MsgBox,262144, MAX PATH ERROR, % "Path to 3Ds Max\Scripts does not exists.`n`nSET CORRECT PATH IN install.ini ""`n`nCURENT PATH:`n`n" $path_max_script
}


/** EXECUTE
  *
  */

if( FileExist($PATH_MAX_SCRIPT) )
	InstallToMaxAndZbrush()

else
	MsgBox,262144, % "PATH NOT EXISTS, PATH DOES NOT EXISTS:`n`n`" $PATH_MAX_SCRIPT "`n`n`EDIT PATH IN:`n`n`    Install-Plugin-Hardlinks.ahk"
