extends Node

class_name DataPath

const ItemData = "res://CSVData/WeaponData.csv"
const PlayerData = "res://CSVData/CharacterBaseStats.csv"
const EnemyData = "res://CSVData/EnemyData.csv"
const StateData = "res://CSVData/States.csv"
const WaveTimer = "res://CSVData/WaveSpawnData.csv"
const PickUpItems = "res://CSVData/PickUpItems.csv"

#TODO if no folder exist create it with the folder + csv file

static func IsStandalone() -> bool:
	if OS.has_feature("standalone"):
		return true

	return false
	pass

static func GetItemData() -> String:
#	if OS.get_name() == 'HTML5':
#		return
	
	if IsStandalone():
		return OS.get_executable_path().get_base_dir().plus_file("CSVData/WeaponData.csv")
	return ItemData
	pass

static func GetPlayerData() -> String:
	if IsStandalone():
		return OS.get_executable_path().get_base_dir().plus_file("CSVData/CharacterBaseStats.csv")
	return PlayerData
	pass

static func GetEnemyData() -> String:
	if IsStandalone():
		return OS.get_executable_path().get_base_dir().plus_file("CSVData/EnemyData.csv")
	return EnemyData
	pass

static func GetStateData() -> String:
	if IsStandalone():
		return OS.get_executable_path().get_base_dir().plus_file("CSVData/States.csv")
		
	return StateData
	pass

static func GetWaveTimer() -> String:
	if IsStandalone():
		return OS.get_executable_path().get_base_dir().plus_file("CSVData/WaveSpawnData.csv")
		
	return WaveTimer
	pass

static func GetPickUpItems() -> String:
	if IsStandalone():
		return OS.get_executable_path().get_base_dir().plus_file("CSVData/PickUpItems.csv")
		
	return PickUpItems
	pass
