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

	ahk_path = current_path + "/createImportScript.ahk", -- "./createImportScript.ahk"

	Exporter = exporterPlugin.classes[findItem exporterPlugin.classes ObjExp],
	Importer = importerPlugin.classes[findItem importerPlugin.classes ObjImp],

	imported_objects	= #(),

	/** Max to zbrush
	 * 
	 * Exported file name is object name with prefixed with postion in selection for keep order of subtools in zbrush
	 */
	function exportObjToZbrush =
	(
		format "\n"; print "MaxToZbrushSync_v.exportObj()"

		this._clearExportFolder()

		objects_to_export = for o in selection where superClassOf o == GeometryClass collect o

		for i = 1 to objects_to_export.count do 
		(
			obj = objects_to_export[i]
			
			select obj

			exportFile ( export_dir + "/"+ i as string + "-_-" + obj.name + ".obj" ) #noPrompt selectedOnly:true using:Exporter
		)

		select objects_to_export

		DOSCommand ("Start \"\" \""+ahk_path+"\"")
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
						
			this._replaceImportedObjects(objects_before_import)( selection[1] )( getFilenameFile( file ))
		)

		select imported_objects
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
	function _replaceImportedObjects objects_before_import imported_object imported_object_name =
	(
		--format "\n"; print "MaxToZbrushSync_v._replaceImportedObjects()"
		delete_imported = false
		
		for obj in objects_before_import where obj.name == imported_object_name do 
		(
			if ( instances = this._getInstances(obj)).count == 0 then
			(
				imported_object.name	= obj.name
				imported_object.pivot	= obj.pivot
				imported_object.wirecolor	= obj.wirecolor
				imported_object.transform	= obj.transform
				imported_object.material	= obj.material
				
				this._relinkHierarchy(obj)(imported_object)
				
				append imported_objects imported_object

				delete obj
			)
			else
			(
				append imported_objects instances[1]

				for _instance in instances do 
					instanceReplace _instance imported_object
				
				delete_imported = true
			)
		)
		
		delete imported_object
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
	
	/** Relink hierarchy
	 */
	function _relinkHierarchy source_object target_object =
	(
		--format "\n"; print "GroupCreator_v._relinkHierarchy()"
		if source_object != undefined then
			target_object.parent = source_object.parent
	
		for child in source_object.children do
			child.parent = target_object
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
