extends Node2D

var isCleared = true
var SpawnTimer = 60*0.5
var ClearTimer = 0.0

var EnemyList = []

func _ready():
	
	set_process(false)
	yield(get_tree().create_timer(0.25), "timeout")
	set_process(true)
	pass

func _process(delta): #make that event driffen, SpawnEvent in levelManager, if timer == Spawn This camp
	SpawnCamp()
	printerr("does camp proses rrun")
	pass

func SpawnCamp():
	if ClearTimer < LevelManager.LevelTimer and isCleared == true: #ClearTimer +  < 10.0Min
#		var CSVDATA = GameFunction.readCSV(DataPath.GetEnemyData())
		var CSVDATA
		for chickEnemie in GameFunction.readJson('res://CSVData/EnemyData.json'):
			if chickEnemie.id == "Chick":
				CSVDATA = chickEnemie
			pass
		var Enemy = preload("res://Nodes/Enemies/BossEnemy.tscn")
		var EnemyInstance = GameFunction.SpawnActor(Enemy, position, 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer)
		EnemyInstance.TakeDamageModArray.append(preload("res://Nodes/TakeDamageMods/TakeDamageModHealFromDamage.tres"))
		EnemyInstance.connect("OnDeath", self, "OnEnemyDeath")
		EnemyInstance.connect("OnTakeDamage", self, "OnTakeDamage")
		EnemyList.append(EnemyInstance)
		
		#SpawnChick
		var enemy2 = load(CSVDATA["ResourcePath"])
		var enemy2Script = load(CSVDATA["ScriptPath"])
#		var enemy2Script = load(CSVDATA["Chick"]["ScriptPath"])
		var EnemyInstance2 = GameFunction.SpawnActor(enemy2, position + Vector2(25, -25), 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer)
		EnemyInstance2.set_script(enemy2Script)
		EnemyInstance2.InitStats("Chick")
		EnemyInstance2.connect("OnDeath", self, "OnEnemyDeath")
		EnemyInstance2.connect("OnTakeDamage", self, "OnTakeDamage")
		EnemyInstance2.Triggered(false)
		EnemyInstance2.TakeDamageModArray.append(preload("res://Nodes/TakeDamageMods/TakeDamageModHealFromDamage.tres"))
		EnemyList.append(EnemyInstance2)
		
		isCleared = false
		set_process(false)
	pass

func OnTakeDamage():
	for Enemy in EnemyList:
		Enemy.Triggered(true)
	pass

func OnEnemyDeath(Enemy):
	EnemyList.erase(Enemy)
	
	if EnemyList.size() <= 0:
		ClearTimer = LevelManager.LevelTimer + SpawnTimer
		isCleared = true
		set_process(true)
	pass
