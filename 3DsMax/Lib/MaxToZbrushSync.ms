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

	preset_export_file	= current_path + "/Presets/gw_objexp.ini",
	preset_import_file	= current_path + "/Presets/gw_objimp.ini",

	ahk_path = current_path + "/createImportScript.ahk", -- "./createImportScript.ahk"

	preset_import = importerPlugin.classes[findItem importerPlugin.classes ObjImp].getIniName(),

	/* dependency */
	/* reference */

	/* inhered */

	/** Max to zbrush
	 */
	function exportObjToZbrush =
	(
		--format "\n"; print "MaxToZbrushSync_v.exportObj()"

		this._clearExportFolder()

		--export_filename	= if maxFileName != "" then trimRight(maxFileName) ".max" else selection[1].name
		this._setPresetFile (preset_export_file) ( exporterPlugin.classes[findItem exporterPlugin.classes ObjExp].getIniName() )

		objects_to_export = for o in selection where superClassOf o == GeometryClass collect o

		for obj in objects_to_export do
		(
			select obj

			exportFile ( export_dir + "/" + obj.name + ".obj" ) #noPrompt selectedOnly:true using:ObjExp
		)

			--export_file_path	= export_dir + "/" + export_filename + ".obj"


		DOSCommand ("Start \"\" \""+ahk_path+"\"")
	),

	/** Zbrush to max
	 */
	function importObjToMax =
	(
		--format "\n"; print "MaxToZbrushSync_v.importObj()"
		obj_files = getFiles (export_dir + "\\*.obj")

		this._setPresetFile (preset_import_file) ( importerPlugin.classes[findItem importerPlugin.classes ObjImp].getIniName() )

		objects_before_import = for o in geometry collect o

		importFile obj_files[1] #noPrompt using:ObjImp
		--importFile obj_files[1] using:ObjImp

		--this._replaceImportedObjects( objects_before_import )( selection as Array )
	),


	private


	/** Set preset file
	 */
	function _setPresetFile preset_file exporter_preset_path =
	(
		--format "\n"; print "MaxToZbrushSync_v.setPresetFile()"
		deleteFile exporter_preset_path

		copyFile preset_file exporter_preset_path
	),

	/** Replace imported objects
	 */
	function _replaceImportedObjects objects_before_import imported_objects =
	(
		clearListener()
		format "\n"; print "MaxToZbrushSync_v._replaceImportedObjects()"
		format "objects_before_import	= % \n" objects_before_import
		format "imported_objects	= % \n" imported_objects

		objects_names_before_import = for o in objects_before_import collect o.name

		--for imported_object in imported_objects where ( index = findItem objects_names_before_import imported_object.name ) > 0 do
		--	format "imported_object	= % \n" imported_object

		for imported_object in imported_objects where ( index = findItem objects_names_before_import imported_object.name ) > 0 do
		(
			format "index	= % \n" index


		)
	),


	/** Clear export folder
	  * remove ".obj" and ".mtl" files
	 */
	function _clearExportFolder =
	(
		for file in getFiles (export_dir + "/*.*") where matchPattern file pattern:"*.obj" or matchPattern file pattern:"*.mtl" do
			deleteFile file
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "MaxToZbrushSync.onCreate()"
		makeDir export_dir all:true
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
