
/** Max to zbrush sync
  *
  * HOW TO GET LOCATION OF INI FILES
  *
  *
		CMD:	objImp.getPresetIniName ()
		RESULT:	"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\en-US\plugcfg\gw_objimp.ini"

		CMD:	objImp.getIniName ()
		RESULT:	"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\en-US\plugcfg\gw_objimp_presets.ini"



  *
  * [ObjExp:ExporterPlugin](https://help.autodesk.com/view/3DSMAX/2020/ENU/?guid=GUID-4BAF2F8E-4EAC-4276-A9A7-FF80EE597A45)
 */
struct MaxToZbrushSync_v
(
	/* construct */

	/* properties */
	export_dir	= "c:/Windows/Temp/_ZBRUSH_MAX_SYNC", -- TODO: PATH SHOULD BE DEFINED IN SOME INI FILE

	current_path = getFilenamePath(getSourceFileName()),

	create_import_script	= current_path + "/createImportScript.ahk", -- "./createImportScript.ahk"

	Exporter = exporterPlugin.classes[findItem exporterPlugin.classes ObjExp],
	Importer = importerPlugin.classes[findItem importerPlugin.classes ObjImp],

	objects_to_export	= #(),
	imported_objects	= #(),

	/** Max to zbrush
	 *
	 * Exported file name is object name with prefixed with postion in selection for keep order of subtools in zbrush
	 */
	function exportObjToZbrush =
	(
		format "\n"; print "MaxToZbrushSync_v.exportObj()"


		this._createExportDir()

		this._clearExportDir()

		objects_to_export = for o in selection where superClassOf o == GeometryClass collect o

		for i = 1 to objects_to_export.count do
			this._exportObject(i)

		select objects_to_export

		DOSCommand ("Start \"\" \""+create_import_script+"\"")

		format "Exported to Zbrush: % \n" (for o in objects_to_export collect o.name)
	),

	/** Zbrush to max
	 */
	function importObjToMax =
	(
		--format "\n"; print "MaxToZbrushSync_v.importObj()"
		obj_files	= getFiles (export_dir + "\\*.obj")
		imported_objects	= #()

		objects_before_import = for o in geometry collect o

		for file in obj_files do
		(
			importFile file #noPrompt using:Importer

			imported_polygroups = selection as Array

			if imported_polygroups.count > 1 then
			(
				this._addMaterialModifier(imported_polygroups)

				for i = imported_polygroups.count to 2 by -1 do
					polyop.attach imported_polygroups[1] imported_polygroups[i]

				imported_obj = imported_polygroups[1]

				append imported_objects imported_obj

				addModifier imported_obj (Vertex_Weld threshold:0.001)

				--this._flipUV( imported_obj )

				maxOps.CollapseNodeTo imported_obj 1 true

				--( polyop.weldVertsByThreshold imported_obj #{1..( polyop.getNumVerts imported_obj)}) --weld vetices

			)
			else
				imported_obj = imported_polygroups[1]

			imported_obj.name = getFilenameFile( file )

			this._replaceImportedObjects(objects_before_import)( imported_obj )( imported_obj.name )
		)

		select imported_objects
	),

	/** Add material modifier
	 */
	function _addMaterialModifier imported_objects =
	(
		--format "\n"; print "MaxToZbrushSync_v._addMaterialModifier()"
		--for obj_imported in imported_objects do
		for i = 2 to imported_objects.count do
			addModifier imported_objects[i] (Materialmodifier materialID:i)
	),

	private

	/** Export object with flipped UV`s in V direction
	 */
	function _exportObject index =
	(
		format "\n"; print "MaxToZbrushSync_v._exportObjects()"

		obj = objects_to_export[index]

		--UVWxform = this._flipUV(obj)

		select obj

		exportFile ( export_dir + "/"+ (this._getCounterPrefix (index)) + "-_-" + obj.name + ".obj" ) #noPrompt selectedOnly:true using:Exporter

		--deleteModifier obj UVWxform
	),

	/** Get counter prefix
	 */
	function _getCounterPrefix index =
	(
		--format "\n"; print "MaxToZbrushSync_v._getCounterPrefix()"

		prefix = ""

		for i = 1 to (objects_to_export.count as string ).count - (index as string ).count do prefix += "0"

		prefix + index as string --return
	),

	/** Flip - DEPRECATED - FLIPPING MAPPING IS PROCESSED IN ZBRUSH ON IMPORT AND EXPORT
	 */
	function _flipUV obj =
	(
		--format "\n"; print "MaxToZbrushSync_v.flip()"
		UVWxform = UVW_Xform ()
		UVWxform.V_Flip = 1

		addModifier obj UVWxform

		UVWxform --return
	),

	/** Set preset file
	 */
	function _setPresetFile =
	(
		--format "\n"; print "MaxToZbrushSync_v.setPresetFile()"

		my_preset_dir = getFilenamePath(getSourceFileName()) + "Presets"

		for Imp_or_Exp in #( Exporter, Importer) do
			for target_file in #( Imp_or_Exp.getIniName(), Imp_or_Exp.getPresetIniName() ) do
				if doesFileExist ( ini_preset_path = my_preset_dir + "\\" + filenameFromPath( target_file ) ) then
				(
					deleteFile target_file

					copyFile ini_preset_path target_file
				)
				else
					messageBox ("Missing preset file\n\n`"+ini_preset_path+"\n\nFile is used in ExporterOBJ_v._copyPresetFile()") title:"Missing preset file"  beep:false
	),

	/** Replace imported objects
	 */
	function _replaceImportedObjects objects_before_import obj_imported imported_object_name =
	(
		--format "\n"; print "MaxToZbrushSync_v._replaceImportedObjects()"
		for obj_source in objects_before_import where obj_source.name == imported_object_name do
		(
			instances = this._getInstances(obj_source)

			for inst in instances do

			obj_imported.name	= obj_source.name
			obj_imported.pivot	= obj_source.pivot
			obj_imported.wirecolor	= obj_source.wirecolor
			obj_imported.transform	= obj_source.transform

			ResetXForm	obj_imported
			collapseStack	obj_imported


			if instances.count == 1 then
			(
				this._relinkHierarchy obj_source obj_imported

				delete obj_source
			)
			else
			(
				instanceReplace instances obj_imported

				delete obj_imported
			)
		)
	),

	/** Relink hierarchy
	 */
	function _relinkHierarchy source_object target_object =
	(
		format "\n"; print "GroupCreator_v._relinkHierarchy()"
		format "source_object: % %\n" source_object (getHandleByAnim source_object)
		format "target_object: % %\n" target_object (getHandleByAnim target_object)
		format "target_object.parent: %\n" target_object.parent

		/* RELINK PARENT */
		if source_object != undefined and source_object.parent != undefined then
		(
			print "RELINK"
			target_object.parent = source_object.parent
		)

		/* RELINK CHILDREN */
		for child in source_object.children do
			child.parent = target_object
	),

	/** Get instances
	  *
	 */
	function _getInstances obj  =
	(
		--format "\n"; print "Selection_v.getInstances()"
		instances = #()

		InstanceMgr.GetInstances obj &instances

		instances --return
	),


	/** Create export dir
	 */
	function _createExportDir =
	(
		--format "\n"; print "MaxToZbrushSync_v._vreateExportDir()"
		makeDir export_dir all:true
	),

	/** Clear export folder
	  * remove ".obj" and ".mtl" files
	 */
	function _clearExportDir =
	(
		for file in getFiles (export_dir + "/*.*") where matchPattern file pattern:"*.obj" or matchPattern file pattern:"*.mtl" do
			deleteFile file
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "MaxToZbrushSync.onCreate()"
		this._setPresetFile()

	)
)
