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

		this._clearExportFolder()

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
			
			obj = selection[1]
			
			this._flipUV( obj )

			maxOps.CollapseNodeTo obj 1 true

			this._replaceImportedObjects(objects_before_import)( obj )( getFilenameFile( file ))
		)

		select imported_objects
	),


	private

	/** Export object with flipped UV`s in V direction
	 */
	function _exportObject index =
	(
		--format "\n"; print "MaxToZbrushSync_v._exportObjects()"
		
		obj = objects_to_export[index]
		
		UVWxform = this._flipUV(obj)
		
		select obj

		exportFile ( export_dir + "/"+ (this._getCounterPrefix (index)) + "-_-" + obj.name + ".obj" ) #noPrompt selectedOnly:true using:Exporter

		deleteModifier obj UVWxform
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
	
	/** Flip
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
		--delete_imported = false
		
		for obj in objects_before_import where obj.name == imported_object_name do 
		(
			instances = this._getInstances(obj)

			imported_object.name	= obj.name
			imported_object.pivot	= obj.pivot
			imported_object.wirecolor	= obj.wirecolor
			imported_object.transform	= obj.transform
			
			ResetXForm	imported_object
			collapseStack	imported_object

			if instances.count > 1 then
			(
				instanceReplace instances imported_object
				
				delete imported_object
			)
			else
				delete obj
	
		)
		
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
