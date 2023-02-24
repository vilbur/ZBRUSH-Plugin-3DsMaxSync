#SingleInstance force

/** Flip V coordinates of Vs in *.obj file
  *	
  */

$file := %1%

FileRead, $file_content, %$file%

FileDelete, %$file%

$new_content := ""

Loop, parse, $file_content, `n, `r`
{
	
	if( RegExMatch( A_LoopField, "i)^vt\s([^\s]+)\s([^\s]+)\s([^\s]+)", $match ) )
	{
		
		
		$new_content .= "vt " $match1 " " ( 1.0 - $match2 ) " " $match3 "`n"
	}
	else
		$new_content .= A_LoopField "`n"

}

FileAppend, %$new_content%, %$file%