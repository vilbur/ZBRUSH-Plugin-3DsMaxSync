#SingleInstance force

/** -------------------------------------------
  *
  *    CREATE HARDLINK FOR FILES AND FOLDERS
  *
  * -------------------------------------------
  */



/** Array of source paths for hardlinks
  *
  *	Path will be replace by paths
  *
  */
global $source_paths := ["Zbrush/MaxZbrushSync"
						 ,"Zbrush/MaxZbrushSync.zsc"  ]

/** 2D Array of strings [ "{search}", "{repalce}" ]
  *
  *	Paths in $source_paths will be modified to get target path for hardlink
  *
  * E.G.:
  * 	"AppData/scripts" >>> "C:/Users/%username%/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts"
  *
  */
global $search_and_replaces := [ [ "Zbrush", "C:/Program Files/Pixologic/ZBrush 2022/ZStartup/ZPlugs64" ] ]


/** CREATE HARDLINKS TOS ZBRUSH
 */
createHardlinks( $path_source, $path_link )
{
	$is_folder := InStr( FileExist($path_source), "D" ) != 0

	/*
		REMOVE OLD OCCURENCES
	*/
	if( $is_folder )
		FileRemoveDir, %$path_link%

	else
		FileDelete, %$path_link%


	$file_or_folder	:= $is_folder ? "/d" : ""

	$mklink	:= "mklink " $file_or_folder " """ $path_link """ """ $path_source """"
	;MsgBox,262144,mklink, %$mklink%

	RunWait %comspec% /c %$mklink%,,Hide

}


/** Create Hardlinks To Zbrush
 */
createHardlinksToZbrush()
{
	;MsgBox,262144,search_and_replaces, % $search_and_replaces[1][1]

	For $index, $path in $source_paths
	{
		$dir_split	:= StrSplit( $path, "/",, 2 )
		;MsgBox,262144,path, %$path%

		For $i, $search_and_replace in $search_and_replaces
		{
			;MsgBox,262144,search_and_replace, %$search_and_replace%
			if( $dir_split[1] == $search_and_replace[1] )
			{
				$search	 := $search_and_replace[1]
				$replace := $search_and_replace[2]
			}
		}

		if( $search !="" && $replace !="" )
		{
			$path_source := A_WorkingDir "/" $path
			$path_link :=  StrReplace( $path, $search "/", $replace "/" )

			$path_source	:= RegExReplace( $path_source, "/", "\") ;"
			$path_link	:= RegExReplace( $path_link, "/", "\") ;"

			if( FileExist( $path_source ) )
				createHardlinks( $path_source,	$path_link )
			else
				MsgBox,262144, PATH DOES NOT EXISTS, % "PATH DOES NOT EXISTS:`n`n" $path_source
		}
	}
}

createHardlinksToMax()
{
	$dir_target := "C:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-vilTools3/Rollouts/rollouts-Tools/rollout-ZBRUSH"

	createHardlinks( A_WorkingDir "/3DsMax/Lib",	$dir_target "/Lib" )
	createHardlinks( A_WorkingDir "/3DsMax/MaxToZbrushSync.mcr",	$dir_target "/MaxToZbrushSync.mcr" )

}
/** EXECUTE
  *
  */
createHardlinksToZbrush()

createHardlinksToMax()