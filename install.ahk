#SingleInstance force

/** -------------------------------------------
  *
  *    INSTAll to 3Ds Max and Zbrush
  *
  * -------------------------------------------
  */

global $ini_file := "install.ini"


/**
  *
  */
zbrushInstall()
{
	IniRead, $zbrush_path,	%$ini_file%, zbrush, zplugs

	If FileExist( $zbrush_path )
	{
		$path_source := A_WorkingDir "\\Zbrush"
		$path_target := $zbrush_path

		FileCopyDir,	% $path_source "\\MaxZbrushSync", % $path_target "\\MaxZbrushSync", 1

		FileCopy,	% $path_source "\\MaxZbrushSync.zsc", % $path_target "\\", 1
	}
	else
		MsgBox,262144, ZBRUSH PATH ERROR, % "Path to zbrush plugs does not exists.`n`nSET CORRECT PATH IN install.ini ""`n`nCurent Path: " $zbrush_path
}
/**
  *
  */
maxhInstall()
{
	IniRead, $max_path,	%$ini_file%, max, scripts

	$max_path	:= RegExReplace( $max_path, "%username%", A_UserName ) ;"

	If FileExist( $max_path )
	{
		$path_source := A_WorkingDir "\\3DsMax"
		$path_target := $max_path "\\MaxZbrushSync"

		FileCopyDir,	%$path_source%, %$path_target%, 1
	}
	else
		MsgBox,262144, ZBRUSH PATH ERROR, % "Path to 3Ds Max\Scripts does not exists.`n`nSET CORRECT PATH IN install.ini ""`n`nCurent Path: " $max_path
}


zbrushInstall()
maxhInstall()