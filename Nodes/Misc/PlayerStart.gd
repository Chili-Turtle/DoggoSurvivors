extends Node2D

export var Player : PackedScene
export var SpawnContainer : NodePath

#onready var Weapon = preload("res://Nodes/Weapons/Knife/Knife.tscn")
#onready var Weapon = preload("res://Nodes/Weapons/GeneratedWeapons/GeneratedWeapon.tscn")

func _ready():
	SpawnPlayer()
	pass

func SpawnPlayer():
	
	# try 10 times befor not assigning a player
	for i in range(0, 10):
		if PlayerManager.SelectedPlayerName != "":
			
			# read csv data and assign it to player == PackedScene
			var CSVDATA #= GameFunction.readCSV(DataPath.GetPlayerData())
#			var CSVDATA = GameFunction.readCSV(DataPath.GetPlayerData())
			var PlayerResourcePath
#			if OS.get_name() == 'HTML5':
#				for CharacterStats in GameFunction.readJson('res://CSVData/CharacterBaseStats.json'):
#					if CharacterStats.id == PlayerManager.SelectedPlayerName:
#						PlayerResourcePath = CharacterStats["ResourcePath"]
#				pass
#			else:
#				PlayerResourcePath = str(CSVDATA[PlayerManager.SelectedPlayerName]["ResourcePath"])
#				pass
			
			for CharacterStats in GameFunction.readJson('res://CSVData/CharacterBaseStats.json'):
					if CharacterStats.id == PlayerManager.SelectedPlayerName:
						PlayerResourcePath = CharacterStats["ResourcePath"]
						CSVDATA = CharacterStats
			
			Player = load(PlayerResourcePath)
			
			# Spawn Player
			var PlayerInstance = GameFunction.SpawnActor(Player, position, 0, Vector2(1, 1),get_node(SpawnContainer), get_tree().root.get_viewport()) #LevelManager.GetSpawnContainer() # FIXME Make it so that the level is the first thing thats loads
			
			# add script to player (DIFFERENT MOVE SCRIPTS)
#			var ExternalPlayerScript = load("C:/Users/Michael Sauer/Desktop/ModdingData/AwsomePlayer.gd")
			var ScriptResource = str(CSVDATA["ScriptResourcePath"])
#			var ScriptResource = str(CSVDATA[PlayerManager.SelectedPlayerName]["ScriptResourcePath"])
			var ScriptToLoad
			
#			if OS.get_name() == 'HTML5':
#				for CharacterStats in GameFunction.readJson('res://CSVData/CharacterBaseStats.json'):
#					if CharacterStats.id == PlayerManager.SelectedPlayerName:
#						ScriptToLoad = CharacterStats["ScriptResourcePath"]
#				pass
#			else:
#				if ScriptResource.begins_with('res://') == true:
#					ScriptToLoad = str(CSVDATA[PlayerManager.SelectedPlayerName]["ScriptResourcePath"])
#				else:
#					ScriptToLoad = OS.get_executable_path().get_base_dir().plus_file(ScriptResource)

			for CharacterStats in GameFunction.readJson('res://CSVData/CharacterBaseStats.json'):
				if CharacterStats.id == PlayerManager.SelectedPlayerName:
					ScriptToLoad = CharacterStats["ScriptResourcePath"]
					
			if OS.has_feature("standalone") and OS.get_name() != 'HTML5':
				for CharacterStats in OS.get_executable_path().get_base_dir().plus_file("CSVData/CharacterBaseStats.json"):
					if CharacterStats.id == PlayerManager.SelectedPlayerName:
						ScriptToLoad = CharacterStats["ScriptResourcePath"]
				
			var PlayerScript = load(ScriptToLoad)
			
			PlayerInstance.set_script(PlayerScript)
			
			PlayerManager.set_PlayerPawn(PlayerInstance)
#			get_node(SpawnContainer).add_child(PlayerInstance)
#			PlayerInstance.position = position
			break
		else:
			yield(get_tree().create_timer(0.2), "timeout")
		pass
	
	
