#SingleInstance force

if WinExist("Closing Document ahk_exe ZBrush.exe")
{
	WinActivate

	Send, N
}