extends BaseLevelEvent

class_name GraveyardEvent

var BossSkelly = preload("res://Nodes/Enemies/BossEnemy.tscn")
var EnemieCount = 5
var EventName =  "Graveyard"
var EnemieList : Array
var Succes = false

var EventGUI = preload("res://Nodes/Widget/EventGUI.tscn")
var Notification = preload("res://Nodes/Widget/Notification.tscn")
var GUIInstance = null

func ResetValues():
	Succes = false
	EnemieList  = []
	pass

func AddToViewport():
	# what should you do when you add things to the viewport
	pass

func StartEvent():
	
	GUIInstance = EventGUI.instance()
	UiManager.AddUI(GUIInstance)
	GUIInstance.SetObjective("Enemies 0/%d" %EnemieCount)
	
	var NotificationInst = Notification.instance()
	NotificationInst.SetNotificationText("Enemies appread at the graveyard")
	UiManager.AddUI(NotificationInst)
	
	
	for section in LevelManager.LevelSection:
		if section.SectionName == EventName:
			for i in range(0, EnemieCount):
				var RandomSpawnPoint = section.position + Vector2(rand_range(-section.ColShape.shape.extents.x, section.ColShape.shape.extents.x), rand_range(-section.ColShape.shape.extents.y, section.ColShape.shape.extents.y))
				var BossSkellyInst = GameFunction.SpawnActor(BossSkelly, RandomSpawnPoint, 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer)
				EnemieList.append(BossSkellyInst)
				BossSkellyInst.connect("OnDeath", self, "OnEnemieDeath")
				for body in section.get_overlapping_bodies():
					if body == PlayerManager.PlayerPawn:
						BossSkellyInst.isAggro = true
			return
		pass
	pass

func OnEnemieDeath(_Enemie):
	EnemieList.erase(_Enemie)
	
	var curEnemie = EnemieCount - EnemieList.size()
	if is_instance_valid(GUIInstance):
		GUIInstance.SetObjective("Enemies %d/%d" %[curEnemie, EnemieCount])
	
	if EnemieList.size() <= 0:
		Succes = true
		LevelManager.EndEvent()
	pass

func EndEvent():
	print("Event has ended")
	
	UiManager.RemoveUI(GUIInstance)
	GUIInstance = null
	
	if Succes == false:
		for Enemie in EnemieList:
			if is_instance_valid(Enemie):
				Enemie.DeSpawn()
				print("Event failed")
	else:
		var NotificationInst = Notification.instance()
		NotificationInst.SetNotificationText("Graveyard cured")
		UiManager.AddUI(NotificationInst)
		
	ResetValues()
	pass

func OnPlayerEntered(_Section):
	for enemie in EnemieList:
		enemie.isAggro = true
	pass
