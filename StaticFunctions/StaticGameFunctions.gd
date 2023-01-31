extends Node2D

class_name GameFunction

enum E8WayDir {Left, Right, Up, Down, DiagonalUp_Left, DiagonalUp_Right, DiagonalDown_Left, DiagonalDown_Right}
enum ERotationDirection {Colckwise = 1, CounterClockwise = -1}
enum EWeaponType {Weapon, OnHit, Accesory}

# @param Spawn an actor and assigns it a parent (PackedScene, Pos, Rot, Scale, Parent, Owner) -> PackedScene)
static func SpawnActor(InstancePackedScene, _positon = Vector2(0, 0), _rotation = 0, _scale = Vector2(1, 1), _parent = null, _owner = null) -> PackedScene:
	var instance = InstancePackedScene.instance()
	instance.position = _positon
	instance.rotation = _rotation
	instance.scale = _scale
	_parent.add_child(instance)
	instance.owner = _owner #owner has to be set after add child
	return instance
	pass

# -------- JSON Converter ----------
static func readJson(DataPath : String):
	var file_path = DataPath
	var file = File.new()
	file.open(file_path, File.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	file.close()
	return content_as_dictionary
	pass

# -------- CSV Converter ----------
#static func readCSV(DataPath : String) -> Dictionary: # ignores the first column
#	var CsvData : Array
#	var CsvDic : Dictionary
#	var file = File.new()
#
#	if file.file_exists(DataPath) == false:
#		printerr("File %s not fond" %DataPath)
#		return CsvDic
#
#	file.open(DataPath, file.READ)
#
#	while !file.eof_reached():
#		var csv = file.get_csv_line()
#		CsvData.append(csv)
#	file.close()
#
#	for i in range(CsvData.size() - 2): # row
#		var TempDic : Dictionary
#		for u in range(1, CsvData[0].size()): #colum
#			TempDic[CsvData[0][u]] = CsvData[i+1][u]
#
#		CsvDic[CsvData[i+1][0]] = TempDic
#	return CsvDic

static func AssignResource(ResourceString : String):
	if ResourceString == "none" or ResourceString.empty():
		return null
	
	return load(ResourceString.strip_edges())
	pass

# -------- Get outside Folder ---------- I actually donT need this
func GetAllFilesFromOutsideFolder():
	# Gets the EXE file then the base dir
	var FolderPath = OS.get_executable_path().get_base_dir() + "/AudioClips"
	var files = [] #files of external folder
	
	#Create Folder if non exist (good on a clean install)
	var directory = Directory.new()
	if !directory.dir_exists(FolderPath):
		directory.make_dir(FolderPath)
		print("File created")
	else:
		# find files in folder
		directory.open(FolderPath)
		directory.list_dir_begin()
		
		for i in 50:
			var file = directory.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				files.append(file)
				
		directory.list_dir_end()
	# ------- if else end ------- 
	
	if files.size() <= 0:
		print("no files found")
		return
	
	#get random file
	var randomFile = randi() % files.size()
	
	# get streaming file-path
	var filePath = FolderPath + "/" + files[randomFile]
	#var filePath = OS.get_system_dir(0) + "/JRC/RandJerm.mp3" # old hardcoded
	
	# ---------------> do what with the file, just give out a array
