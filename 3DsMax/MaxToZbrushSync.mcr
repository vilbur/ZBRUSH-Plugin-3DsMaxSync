filein( getFilenamePath(getSourceFileName()) + "/Lib/MaxToZbrushSync.ms" )

/**
  *
  *
 */
macroscript	_3DsMaxSync_to_zbrush
category:	"_3DsMaxSync"
buttontext:	"Max > ZBrush"
toolTip:	""
icon:	"Across:2|width:196|height:48"
--icon:	"Groupbox:Nodes"
--icon:	"control:checkbutton"
(
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
	--messageBox "_3DsMaxSync_to_max" title:"Title"  beep:false
	(MaxToZbrushSync_v()).importObjToMax()
)
