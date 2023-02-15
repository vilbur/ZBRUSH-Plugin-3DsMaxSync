#SingleInstance force


/**
 */
sendFilePathTomaxListener( )
{
	SetTitleMatchMode 2

	;$file_in_command := "messageBox ""Yupiii"""
	$file_in_command := "macros.run ""_3DsMaxSync"" ""_3DsMaxSync_to_max"""

	if WinExist("Autodesk 3ds Max ahk_exe 3dsmax.exe")
	{
		WinActivate

		sleep 500

		ControlSetText , MXS_Scintilla2, %$file_in_command%

		ControlSend, MXS_Scintilla2, {NumpadEnter}
	}
}

sendFilePathTomaxListener()