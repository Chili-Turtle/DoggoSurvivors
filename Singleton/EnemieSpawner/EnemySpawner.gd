extends Node2D

#export var EnemyContainer : NodePath

var SpawnTimer = Timer.new()

#max spawns
var WaveSpawn = [20, 40, 60]

var EnemieSpawnList = []

export var MaxEnemies = 300

var EnemyCount : int = 0

var CSVEnemyDATA #= GameFunction.readCSV(DataPath.GetEnemyData())

#var Enemy1 = preload("res://Nodes/Enemies/SkelletonEnemy.tscn")
#var Enemy2 = preload("res://Nodes/Enemies/SkelletonEnemy.tscn")
#var EnemyArray = []

# should that be in the timer?
# get a list from the csv file
# spawn at once
# camp uses spawn actor

var Gems = preload("res://Nodes/Gems/PickUp.tscn")

var left_bound : float
var right_bound : float
var top_bound : float
var bottum_bound : float

var RightSpawnPoint : Vector2
var LeftSpawnPoint : Vector2
var UpperSpawnPoint : Vector2
var BottumSpawnPoint : Vector2

var CameraSize : Vector2

var can_spawn : bool = false

var SpawnArray : Array

func AddTimer():
	add_child(SpawnTimer)
	SpawnTimer.connect("timeout", self, "_on_Timer_timeout")
	pass

func StartWaveSpawner():
	can_spawn = true
	SpawnTimer.start()
	pass

func ChangeTickRate(WaveTickRate):
	SpawnTimer.start(WaveTickRate)
	pass

func _ready():
	
#	CSVEnemyDATA = GameFunction.readCSV(DataPath.GetEnemyData())
	CSVEnemyDATA = GameFunction.readJson('res://CSVData/EnemyData.json')
	
	AddTimer()
	CameraManager.connect("CameraAdded", self, "OnCameraAdded")
	randomize()
	pass
	
func OnCameraAdded():
	CameraSize = CameraManager.PlayerCamera.get_viewport_rect().size/2 * CameraManager.PlayerCamera.zoom
	pass

func CalcViewportBoarders():
	SpawnArray.clear() #clear/reset the spawn array
	
	# viewport bound
	right_bound = (CameraManager.PlayerCamera.get_camera_screen_center() + CameraSize).x
	bottum_bound = (CameraManager.PlayerCamera.get_camera_screen_center() + CameraSize).y 
	left_bound = (CameraManager.PlayerCamera.get_camera_screen_center() - CameraSize).x
	top_bound = (CameraManager.PlayerCamera.get_camera_screen_center() - CameraSize).y
	
	# random right point
	for i in range(0, 50):
		RightSpawnPoint = Vector2(rand_range(right_bound, right_bound + 100), rand_range(top_bound, bottum_bound))
		var ClosetPoint = Navigation2DServer.map_get_closest_point(LevelManager.SpawnContainer.get_world_2d().navigation_map, RightSpawnPoint)
		if RightSpawnPoint.distance_to(ClosetPoint) < 5.0:
			SpawnArray.append(RightSpawnPoint)
			break
		pass
	
#		print(SpawnArray)

	# random left point
	for u in range(0, 50):
		LeftSpawnPoint = Vector2(rand_range(left_bound -100, left_bound), rand_range(top_bound, bottum_bound))
		var ClosetPoint = Navigation2DServer.map_get_closest_point(LevelManager.SpawnContainer.get_world_2d().navigation_map, LeftSpawnPoint)
		if LeftSpawnPoint.distance_to(ClosetPoint) < 5.0:
			SpawnArray.append(LeftSpawnPoint)
			break

	# random upper point
	for p in range(0, 50):
		UpperSpawnPoint = Vector2(rand_range(left_bound, right_bound), rand_range(bottum_bound, bottum_bound + 100))
		var ClosetPoint = Navigation2DServer.map_get_closest_point(LevelManager.SpawnContainer.get_world_2d().navigation_map, UpperSpawnPoint)
		if UpperSpawnPoint.distance_to(ClosetPoint) < 5.0:
			SpawnArray.append(UpperSpawnPoint)
			break
			
	# random bottum point
	for o in range(0, 50):
		BottumSpawnPoint = Vector2(rand_range(left_bound, right_bound), rand_range(top_bound, top_bound - 100))
		var ClosetPoint = Navigation2DServer.map_get_closest_point(LevelManager.SpawnContainer.get_world_2d().navigation_map, BottumSpawnPoint)
		if BottumSpawnPoint.distance_to(ClosetPoint) < 5.0:
			SpawnArray.append(BottumSpawnPoint)
			break
	pass

# this is my tick spawn
func _on_Timer_timeout():
	if can_spawn == false:
		return

	# spawn radom amount of enemies check if max limit is reached
#	for i in range(0, randi() % WaveSpawn[0] + 1):
	if EnemyCount >= MaxEnemies:
		return

#			enemyInst.position = Vector2(360 + rand_range(-50, 50), 200 + rand_range(0, 50))
	CalcViewportBoarders()
	
	if SpawnArray.size() > 0 and EnemieSpawnList.size() > 0:

		var RandomName = EnemieSpawnList[randi() % EnemieSpawnList.size()]
		var EnemyResource #= load(str(CSVEnemyDATA[RandomName]["ResourcePath"]))
		for enemieRes in CSVEnemyDATA:
			if enemieRes.id == RandomName:
				EnemyResource = load(enemieRes["ResourcePath"])
		
#		var EnemyResource = load(str(CSVEnemyDATA[RandomName]["ResourcePath"]))
		var enemyInst = GameFunction.SpawnActor(EnemyResource, GetRandomSpawnPos(), 0, Vector2(1, 1), LevelManager.GetSpawnContainer())
#		var enemyInst = Enemy1.instance()
		enemyInst.isAggro = true
		enemyInst.InitStats(RandomName)
		enemyInst.connect("OnDeath", self, "OnRemoveEnemy")
		EnemyCount += 1
#		var SpawnPos = GetRandomSpawnPos()
#		enemyInst.position = SpawnPos
#		LevelManager.SpawnContainer.add_child(enemyInst)
	pass

func GetRandomSpawnPos() -> Vector2:
	return SpawnArray[randi() % SpawnArray.size()]
	pass

# spawns an enemie out of view in a circular pattern
func SpawnEnemieCircel(_EnemyName, amount):
	CalcViewportBoarders()
	var SpawnPos = GetRandomSpawnPos()
	var curAngle = 0.0
	for i in range(0, amount):
			if SpawnArray.size() > 0:
				var EnemyResource = load(str(CSVEnemyDATA[_EnemyName]["ResourcePath"]))
				var enemyInst = EnemyResource.instance()
				
#				enemyInst.isAggro = isAggro
				enemyInst.InitStats(_EnemyName) ###########################
				
				enemyInst.position = SpawnPos + Vector2(cos(curAngle) , sin(curAngle)) * 10
				curAngle += (PI*2) / amount
				LevelManager.SpawnContainer.add_child(enemyInst)
	pass
	
# [int(EnemyArr[0]), load(str(EnemyResourcePath))] -> amount and Resource
func SpawnEnemieWaveAtBoarder(Enemies = [[0, "ResourcePath", "EnemyName"]], isAggro = true):
#	return #DEBUG del this line
	if can_spawn == false:
		return #TODO

	# Get all enmies [ [10, "EnemyPath"], ] and spawn them
	for EnemieArr in Enemies:
		# spawn enemies amount
		for i in range(0, EnemieArr[0]):
			CalcViewportBoarders()
			var enemyInst = GameFunction.SpawnActor(EnemieArr[1], GetRandomSpawnPos(), 0, Vector2(1, 1), LevelManager.GetSpawnContainer())
			enemyInst.InitStats(EnemieArr[2])
			enemyInst.isAggro = isAggro
		pass
	pass

func OnRemoveEnemy(KilledActor):
	EnemyCount -= 1
	pass

func DebugSpawnStuff(Stuff):
	var stuffInst = Stuff.instance()
	stuffInst.position = Vector2(360 + rand_range(-100, 100), 200 + rand_range(-100, 100))
	LevelManager.SpawnContainer.add_child(stuffInst)
	pass
