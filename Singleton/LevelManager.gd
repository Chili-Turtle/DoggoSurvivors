extends Node

# TODO have a ItemPool for new resource and ItemPool for Items in your inventory, the make a function get_item_pool which gets all the items in the combined pool
var ItemPool = []
var LevelTimer = 0.0

# do I need this? -> var CampData : Array = [[Vector2(), false, 0.0, 200.0]] #[Pos, Cleared, cleared timer, SpawnTimer], have A camp scene, where all camps are listed

var LevelEvents = [load("res://Nodes/LevelEvents/GraveyardEvent.tres"), load("res://Nodes/LevelEvents/OnionHuntEvent.tres")] #, load("res://Nodes/LevelEvents/OnionHuntEvent.tres"),  load("res://Nodes/LevelEvents/GraveyardEvent.tres")

var SpawnContainer : Node

var WaveData
var CurWaveIndex = 0
var NextTime = 0.0

func _ready():
	set_process(false)
	
#	WaveData = GameFunction.readCSV(DataPath.GetWaveTimer())
	WaveData = GameFunction.readJson('res://CSVData/WaveSpawnData.json')
	
#	NextTime  = float(WaveData.values()[CurWaveIndex]["NextWaveTimer"])
	NextTime  = float(WaveData[CurWaveIndex]["NextWaveTimer"])
	
	# HACK change this so it supports all of the stuff
	ItemPool = ["OnHitSpikes", "Whip", "Bomba"] #FIXME problem, when the name of an item is here multiple times, it messes with the random chance
	pass

func GetSpawnContainer():
	if SpawnContainer != null:
		return SpawnContainer
	else:
		return get_tree().root.get_viewport()
	pass

########## Item Pool ########## # TODO put this into a resource maybe? (ItemPoolResource) # have a ItemPool for new resource and ItemPool for Items in your inventory
func AddToItemPool(ItemName : String):
	if ItemPool.has(ItemName):
		return

	ItemPool.append(ItemName)

	print("----------------------------------> Item Pool {ItemPool}".format({"ItemPool": ItemPool}))
	pass

func RemoveFromItemPool(ItemName : String):
	ItemPool.erase(ItemName)
	print("Removed %s" % ItemName)
	print("----------------------------------> Item Pool {ItemPool}".format({"ItemPool": ItemPool}))
	pass
	
func GetRandomItemFromItemPool() -> String:
	# if Itempool is empty
	if ItemPool.empty():
		return ""
	
	var RandItem = ItemPool[randi() % ItemPool.size()-1]
	print(RandItem)
	print("----------------------------------> Item Pool {ItemPool}".format({"ItemPool": ItemPool}))
	return RandItem
########## Item Pool ##########

########## Level Start Time ##########
func OnLevelStart():
	set_process(true)
	pass

func _process(delta):
	LevelTimer += delta
	# check for wave state
	CheckWaves()
	StartEvents()
	
########## Level Start Time ##########

########## Waves ########## now phases
func CheckWaves():
	
#	print(WaveData["Wave0"])
	
	if LevelTimer >= NextTime:
		var WaveSpawn = str(WaveData[CurWaveIndex]["WaveSpawnEnemies"])
		var EnemyData# = GameFunction.readCSV(DataPath.GetEnemyData())
		
#		if OS.get_name() == 'HTML5':
#			EnemyData = GameFunction.readJson('res://CSVData/EnemyData.json')
#			pass
#		else:
#			EnemyData = GameFunction.readCSV(DataPath.GetEnemyData())
#			pass
		
#		EnemyData# = GameFunction.readJson('res://CSVData/EnemyData.json')
		
		#get the EnemieWave spawn amount and name
		var EnemyWaveSpawnArr : Array
		var SplitArr = WaveSpawn.split(",", false)
		for enemie in SplitArr:
			var EnemyArr = enemie.split(" ", false) #Amount and Name
			
			for enemieRes in GameFunction.readJson('res://CSVData/EnemyData.json'):
				if enemieRes.id == EnemyArr[1]:
					EnemyData = enemieRes
			
			var EnemyResourcePath = EnemyData["ResourcePath"] # get resource path
#			if OS.get_name() == 'HTML5':
#				for enemieRes in GameFunction.readJson('res://CSVData/EnemyData.json'):
#					if enemieRes.id == EnemyArr[1]:
#						EnemyData = enemieRes["ResourcePath"]
#						pass
#				pass
#			else:
#				EnemyResourcePath = EnemyData[EnemyArr[1]]["ResourcePath"] # get resource path
#				pass
			
			# [Amount, ResourcePath, EnemyName]
			EnemyWaveSpawnArr.append([int(EnemyArr[0]), load(str(EnemyResourcePath)) , EnemyArr[1]]) # add to Wave Spawn Array
		
		var SpawnTickRate = float(WaveData[CurWaveIndex]["SpawnTick"])
		
		# Get TickSpawnList from CsvData
		var TickSpawn = str(WaveData[CurWaveIndex]["TickSpawnEnemies"]).split(",", false)
#		var TickSpawn = str(WaveData.values()[CurWaveIndex]["TickSpawnEnemies"]).split(",", false)
		
		for TickEnemie in TickSpawn:
			var EnemieName = TickEnemie.replace(" ", "")
#			var EnemyResourcePath = EnemyData[EnemieName]["ResourcePath"]
#			EnemySpawner.EnemieSpawnList.append(load(str(EnemyResourcePath)))
			EnemySpawner.EnemieSpawnList.append(EnemieName)
		
		EnemySpawner.SpawnEnemieWaveAtBoarder(EnemyWaveSpawnArr, true)
		EnemySpawner.ChangeTickRate(SpawnTickRate)
		
		CurWaveIndex += 1
		NextTime  = float(WaveData[CurWaveIndex]["NextWaveTimer"])
		pass
	
	# get data from csv
	# set spawn tick active in enemy script
	# set wave spawn amount
	# set next spawn wave
	
	# if nextSpawnWave <= 0: spanw next wave
	
	# load it to a wave resource + arry // ArrayOfWave = [Wave1, Wave2]
	# Wave Array has all the vars
	
	# next next wave data
	pass
########## Waves ##########


########## Events ##########
var EventTimer = RandomTime(0.1, 1.2)
var CurrentEvent = null

func RandomTime(MinTime, MaxTime):
	return rand_range(60*MinTime, 60*MaxTime)
	pass

func AddEvent(_Event : Resource):
	LevelEvents.append(_Event)
	pass

func GetRandomEvent():
	var RandEvent = LevelEvents[randi() % LevelEvents.size()]
	CurrentEvent = RandEvent
	return RandEvent
	pass

func StartEvents():

	if  LevelTimer > EventTimer:
		if CurrentEvent != null:
			EndEvent()
		printerr("event is starting? 2")
		GetRandomEvent().StartEvent()
		#reset the timer
		EventTimer = LevelTimer + RandomTime(1.0, 1.5)
	pass

func EndEvent():
	if is_instance_valid(CurrentEvent):
		CurrentEvent.EndEvent()
		printerr("event ended?")
		CurrentEvent = null
	pass

func OnPlayerEnteredSection(body, _Section):
	if CurrentEvent == null:
		return

	if _Section.SectionName == CurrentEvent.EventName:
		for body in _Section.get_overlapping_bodies():
			printerr("levelManager: player entered event area")
			if body == PlayerManager.PlayerPawn:
				CurrentEvent.OnPlayerEntered(_Section)
	pass

var LevelSection : Array
func AddLevelSection(_LevelSection : Area2D): # called in AddLevelSection
	LevelSection.append(_LevelSection)
	_LevelSection.connect("body_entered", self, "OnPlayerEnteredSection", [_LevelSection])
	pass
