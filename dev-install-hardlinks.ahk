#SingleInstance force

#SingleInstance force
#NoTrayIcon

/** Create Hardlinks of file or folder
  *
  *	Original path is deleted or renamed, depends on original_suffix property
  *
  *	@param string original_suffix suffix added on original file or folder if exists, IF EMPTY THEN ORIGINAL FILE OR FOLDER IS DELETED
  */
Class HardLinkCreator
{
	original_suffix	:= ""

	__New( $original_suffix := "" )
	{
		this.original_suffix := $original_suffix
	}

	/** CREATE HARDLINKS TOS ZBRUSH
	 */
	create( $path_source, $path_link )
	{
		$path_source	:= this._sanitizeBackslashes( $path_source )
		$path_link	:= this._sanitizeBackslashes( $path_link )

		if( FileExist($path_source) )
		{

			if( this._isHardlink( $path_link ) || this.original_suffix == "" )
				this._deleteFileOrFolder( $path_link )

			else
				this._renameOriginal( $path_link )


			$file_or_folder	:= this._isDirecotry( $path_source )  ? "/d" : ""

			$mklink	:= "mklink " $file_or_folder " """ $path_link """ """ $path_source """"

			;MsgBox,262144,mklink, %$mklink%
			RunWait %comspec% /c %$mklink%,,Hide
		}
	}

	/**
	 */
	_deleteFileOrFolder( $path_link )
	{
		if( this._isDirecotry( $path_link ) )
			FileRemoveDir, %$path_link%, 1

		else
			FileDelete, %$path_link%
	}

	/**
	 */
	_renameOriginal( $path_link )
	{
		$path_target_bak	:= $path_link "." this.original_suffix

		if( this._isDirecotry( $path_link ) )
			FileMoveDir, %$path_link%, %$path_target_bak%
		else
			FileMove, %$path_link%, %$path_target_bak%
	}

	/**
	 */
	_isHardlink( $path )
	{
		SplitPath, $path, $dir_name, $path_parent

		ObjShell.Exec( ComSpec " /c dir /al /s c:\*.*")

		$objShell	:= ComObjCreate("WScript.Shell")
		$objExec	:= $objShell.Exec( ComSpec " /c dir """ $path_parent """ | find /i ""<SYMLINK""")

		$objExec_result := $objExec.StdOut.ReadAll()

		return RegExMatch( $objExec_result, "<SYMLINKD*>\s+" $dir_name ) ? 1 : 0
	}

	/**
	 */
	_isDirecotry( $path )
	{
		return InStr( FileExist($path), "D" ) != 0
	}

	/**
	 */
	_sanitizeBackslashes( $path )
	{
		return % RegExReplace( $path, "[/\\]+", "\") ;"
	}
}

/*
 * Create Hardlinks
 */
$path_source	:= A_WorkingDir "/AppData"
$path_link 	:= ""

$HardLinkCreator	:= new HardLinkCreator("Default")	; Rename original file or folder with this suffix
;$HardLinkCreator	:= new HardLinkCreator()	; Delete original



$dir_target := "C:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-vilTools3/Rollouts/rollouts-Tools/rollout-ZBRUSH"

$HardLinkCreator.create( A_WorkingDir "/3DsMax/Lib",	$dir_target "/Lib" )
$HardLinkCreator.create( A_WorkingDir "/3DsMax/MaxToZbrushSync.mcr",	$dir_target "/MaxToZbrushSync.mcr" )

