/** Max to zbrush sync
  *
  *
  * [ObjExp:ExporterPlugin](https://help.autodesk.com/view/3DSMAX/2020/ENU/?guid=GUID-4BAF2F8E-4EAC-4276-A9A7-FF80EE597A45)
 */
struct MaxToZbrushSync_v
(
	/* construct */


	/* properties */
	export_dir	= "c:/Windows/Temp/_ZBRUSH_MAX_SYNC",


	current_path = getFilenamePath(getSourceFileName()),

	preset_export_file	= current_path + "/Presets/obj_exporter_settings.ini",
	preset_import_file	= current_path + "/Presets/obj_importer_settings.ini",

	ahk_path = current_path + "/importToZbrush.ahk",

	preset_export = exporterPlugin.classes[findItem exporterPlugin.classes ObjExp].getIniName(),
	preset_import = importerPlugin.classes[findItem importerPlugin.classes ObjImp].getIniName(),

	/* dependency */
	/* reference */

	/* inhered */

	/** Max to zbrush
	 */
	function exportObj =
	(
		format "\n"; print "MaxToZbrushSync_v.exportObj()"
		export_filename	= if maxFileName != "" then trimRight(maxFileName) ".max" else selection[1].name
		export_path	= export_dir + "/" + export_filename + ".obj"

		makeDir export_dir all:true


		deleteFile preset_export

		copyFile preset_export_file preset_export

		exportFile export_path #noPrompt selectedOnly:true --using:exporter

		DOSCommand ("Start \"\" \""+ahk_path+"\" \""+export_path+"\"")
	),

	/** Zbrush to max
	 */
	function importObj =
	(
		--format "\n"; print "MaxToZbrushSync_v.importObj()"
		obj_files = getFiles (export_dir + "\\*.obj")

		format "obj_files	= % \n" obj_files

		importFile obj_files[1] #noPrompt --using:<maxclass>

	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "MaxToZbrushSync.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
