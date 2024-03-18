
/**
  *
  *
 */
macroscript	_3DsMaxSync_to_zbrush
category:	"_3DsMaxSync"
buttontext:	"Max > ZBrush"
toolTip:	""
icon:	"Across:2|width:190|height:48"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(
	--/* IMPORT ZBRUSH PLUGIN */
	--filein @"C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins\INSTALLED\MaxZbrushSync\3DsMax\Lib\MaxToZbrushSync.ms" --"./../../../../../../../../../../../../../../../GoogleDrive/ProgramsData/CG/ZBrush/Plugins/INSTALLED/MaxZbrushSync/3DsMax/Lib/MaxToZbrushSync.ms"

	(MaxToZbrushSync_v()).exportObjToZbrush()
)

/**
  *
 */
macroscript	_3DsMaxSync_to_max
category:	"_3DsMaxSync"
buttontext:	"ZBrush > Max"
toolTip:	""
--icon:	"Across:2"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(

	--/* IMPORT ZBRUSH PLUGIN */
	--filein @"C:\GoogleDrive\ProgramsData\CG\ZBrush\Plugins\INSTALLED\MaxZbrushSync\3DsMax\Lib\MaxToZbrushSync.ms" --"./../../../../../../../../../../../../../../../GoogleDrive/ProgramsData/CG/ZBrush/Plugins/INSTALLED/MaxZbrushSync/3DsMax/Lib/MaxToZbrushSync.ms"

	undo "Import Zbrush" on
	(
		(MaxToZbrushSync_v()).importObjToMax()
	)

)