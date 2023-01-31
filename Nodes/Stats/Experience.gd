extends Node

# Fix pls How the fuck do you make the csv into this without loading it on runtime, caching it in a array level for level sound autistic

var CurExperience : float = 0.0
var NextLvLExperience : float = 5.0

var PlayerLevel : int = 1

var LevelUpGUI = preload("res://Nodes/Widget/LevelUpGUI.tscn")

func CaclXpForNextLevel(): # Don't know if I should use a csv for that or not?
	if PlayerLevel < 20:
		NextLvLExperience = NextLvLExperience + 10 # NextLVLExperience = Level-1 * 5
		pass
	elif PlayerLevel < 40:
		NextLvLExperience = NextLvLExperience + 13
		pass
	else:
		NextLvLExperience = NextLvLExperience + 16
		pass
	pass

signal OnTakeExperience()
signal OnAddExperience()
signal OnLevelUp()

func _ready():
	pass

func AssignStats(Stats):
	CurExperience = Stats.Experience
	PlayerLevel = Stats.Level
	pass

func ResetExperience():
	CurExperience = NextLvLExperience
	pass 

func AddExperience(ExperienceAmount : float):
	CurExperience += ExperienceAmount
	emit_signal("OnAddExperience")
	
	if CurExperience >= NextLvLExperience:
		PlayerLevel += 1
		emit_signal("OnLevelUp")
		var Difference = CurExperience - NextLvLExperience
		CurExperience = 0.0
		printerr("Experiecne: how often?")
		UiManager.AddUI(LevelUpGUI.instance(), true)
		CaclXpForNextLevel()
#		NextLvLExperience *= 2.0
		owner.Health.AddHealth(owner.CurStats.AMaxHealth)
		AddExperience(Difference) # ~recursively adding the overshooting expirience (repeating the checks)
		pass
	
	pass

func TakeExperience(instigator : Object, ExperienceLeech : float):
	CurExperience -= ExperienceLeech
	emit_signal("OnTakeExperience")
	
	if CurExperience <= 0:
		print("Remove level")
	pass
