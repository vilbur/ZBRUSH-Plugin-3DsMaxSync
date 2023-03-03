#SingleInstance force

/** -------------------------------------------
  *
  *    CREATE HARDLINK FOR FILES AND FOLDERS
  *
  * -------------------------------------------
  */
createHardlinksToMax()
{
	$dir_target := "C:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-vilTools3/Rollouts/rollouts-Tools/rollout-ZBRUSH"

	createHardlinks( A_WorkingDir "/3DsMax/Lib",	$dir_target "/Lib" )
	createHardlinks( A_WorkingDir "/3DsMax/MaxToZbrushSync.mcr",	$dir_target "/MaxToZbrushSync.mcr" )

}
/** EXECUTE
  *
  */
createHardlinksToMax()