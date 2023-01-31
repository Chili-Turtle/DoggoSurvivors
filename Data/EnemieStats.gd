extends Resource

class_name EnemieStats

var EnemieLevel : int = 1
var EnemieName : String
var CurHealth : float
var AMaxHealth : float
# var ExperienceGain : float
var AttackPoints : float
var BaseMovementSpeed : float
var Weight : float 
var SpriteResource : Resource
var StartWeapons : Array
var HealthRegen : float
var AddHealthRegen : float = 0.0

func AssignBaseStats(_CharacterName = "", DataPathString = "res://CSVData/EnemyData.json"): # caches the base stats
#	var BaseStatsCSV : Dictionary = GameFunction.readCSV(DataPathString)
	var BaseStatsCSV# : Dictionary = GameFunction.readCSV(DataPathString)
	for data in GameFunction.readJson(DataPathString):
		if data.id == _CharacterName:
			BaseStatsCSV = data
	EnemieName = str(BaseStatsCSV["EnemyName"])
	AMaxHealth = float(BaseStatsCSV["Health"])
	BaseMovementSpeed = float(BaseStatsCSV["MovementSpeed"])
	AttackPoints = float(BaseStatsCSV["AttackPoints"])
	HealthRegen = float(BaseStatsCSV["HealthRegen"])
	Weight = float(BaseStatsCSV["Weight"])
	AssignSprite(BaseStatsCSV, _CharacterName)
	
	for Stringer in BaseStatsCSV["StartWeapons"].split(",", false):
		StartWeapons.append(str(Stringer).strip_edges())
	
	CurHealth = AMaxHealth
	pass

func GetHealthRegen() -> float:
	return HealthRegen + AddHealthRegen
	pass

func AssignSprite(_BaseStatsCSV, _CharacterName):
	
	if str(_BaseStatsCSV["SpritePath"]).get_extension() in ["tres"]:
		SpriteResource = load(str(_BaseStatsCSV["SpritePath"]))
		return
	######## Create sprite frame file (if you provid just a folder with sprites) #############
	else:
		var SpriteAnimation = SpriteFrames.new()
		SpriteAnimation.add_animation("Idle")
		SpriteAnimation.set_animation_speed("Idle", 12)
	# get the directory, get all files and save it in a array
		var dir = Directory.new()
		dir.open(_BaseStatsCSV["SpritePath"]) #for dir you don't have to close them!
		dir.list_dir_begin(true)
		var file = dir.get_next()
		while file != '':
			if file.get_extension()in ["png", "jpg"]: # FIXME or IDK does not work for packed png
				var texture : Texture = load(dir.get_current_dir() + "/" + file)
				SpriteAnimation.add_frame("Idle", texture)
			file = dir.get_next()
		dir.list_dir_end()
		
		#### Death animation
	# get the directory, get all files and save it in a array
		SpriteAnimation.add_animation("Death")
		SpriteAnimation.set_animation_speed("Death", 12)
		SpriteAnimation.set_animation_loop("Death", false)
		var dirRun = Directory.new()
		dirRun.open(_BaseStatsCSV["SpritePathDeath"]) #for dir you don't have to close them!
		dirRun.list_dir_begin(true)
		var fileRun = dirRun.get_next()
		while fileRun != '':
			if fileRun.get_extension()in ["png", "jpg"]:
				var texture : Texture = load(dirRun.get_current_dir() + "/" + fileRun)
				SpriteAnimation.add_frame("Death", texture)
			fileRun = dirRun.get_next()
		dirRun.list_dir_end()
		
		SpriteResource = SpriteAnimation
		return
	pass
