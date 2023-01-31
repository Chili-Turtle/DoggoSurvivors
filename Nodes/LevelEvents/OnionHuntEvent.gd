extends BaseLevelEvent

class_name OnionHuntEvent

var Onion = preload("res://Nodes/LevelEvents/Onion.tscn")
var OnionCount = 2
var EventName =  "Onion"
var OnionList : Array
var Succes = false

var EventGUI = preload("res://Nodes/Widget/EventGUI.tscn")
var Notification = preload("res://Nodes/Widget/Notification.tscn")
var GUIInstance = null

func ResetValues():
	Succes = false
	OnionList = []
	pass

func StartEvent():
	
	GUIInstance = EventGUI.instance()
	#UiManager.AddUI(GUIInstance)
	GUIInstance.SetObjective("Onions 0/%d" %OnionCount)
	
	var NotificationInst = Notification.instance()
	NotificationInst.SetNotificationText("Onions appeared on the shore")
	UiManager.AddUI(NotificationInst)
	
	printerr("Find the onions")
	for section in LevelManager.LevelSection:
		if section.SectionName == EventName:
			for i in range(0, OnionCount):
				var RandomSpawnPoint = section.position + Vector2(rand_range(-section.ColShape.shape.extents.x, section.ColShape.shape.extents.x), rand_range(-section.ColShape.shape.extents.y, section.ColShape.shape.extents.y))
				var OnionInst = GameFunction.SpawnActor(Onion, RandomSpawnPoint, 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer)
				OnionList.append(OnionInst)
				OnionInst.connect("OnCollected", self, "OnCollected")
			return
		pass
	pass

func OnCollected(_Onion):
	OnionList.erase(_Onion)
	
	var curOnion = OnionCount - OnionList.size()
	GUIInstance.SetObjective("Onions %d/%d" %[curOnion, OnionCount])
	
	if OnionList.size() <= 0:
		Succes = true
		LevelManager.EndEvent()
	pass

func EndEvent():
	print("Event has ended")
	
	UiManager.RemoveUI(GUIInstance)
	GUIInstance = null
	
	if Succes == false:
		for Onion in OnionList:
			if is_instance_valid(Onion):
				Onion.DeSpawn()
				print("Event failed")
	else:
		print("Event succes")
		var NotificationInst = Notification.instance()
		NotificationInst.SetNotificationText("All Onions collected")
		UiManager.AddUI(NotificationInst)
	
	pass

func OnPlayerEntered(_Section):
	pass
