class_name PickUp # Makes it appear in the Add node tab
extends Area2D

func get_class(): return "PickUp"
func is_class(value) : return true if value == "PickUp" else false

# Data Stuff
var AnimationPath # if sprite has animation
var SoundFile
var Value
# Data Stuff

# TODO How Do I Init my Pickups/ the kinda act a little bit different 

var tweener : Tween
var is_picked_up = false

func _ready():
	tweener = Tween.new()
	tweener.connect("tween_completed", self, "_on_Tween_tween_completed")
	add_child(tweener)
	set_process(false)
	pass

func OnStartPickUp():
	if is_instance_valid(PlayerManager.PlayerPawn):
		if !tweener.is_active():
			tweener.follow_property(self, "position", position, PlayerManager.PlayerPawn, "position", 1.0, Tween.TRANS_BACK, Tween.EASE_IN, 0.0)
			tweener.start()
	pass

func OnPickUp():
	if is_instance_valid(self):
		queue_free()
	pass

func _on_Tween_tween_completed(object, key):
	OnPickUp()
	pass

func InitData(PickUpName : String):
	var CSVDATA# = GameFunction.readJson('res://CSVData/PickUpItems.json')
#	var CSVDATA = GameFunction.readCSV(DataPath.GetPickUpItems())

	for pickup in GameFunction.readJson('res://CSVData/PickUpItems.json'):
		if pickup.id == PickUpName:
			CSVDATA = pickup
			pass

	$Sprite.texture = AssignResource(CSVDATA["TexturePath"])
	$Sprite.hframes = int(CSVDATA["hframes"])
#	$Sprite.hframes = int(CSVDATA[PickUpName]["hframes"])
	$Sprite.vframes = int(CSVDATA["vframes"])
	$Sprite.frame = int(CSVDATA["Curframe"])
	Value =  float(CSVDATA["Value"])
	AnimationPath = AssignResource(CSVDATA["AnimationPath"])
	SoundFile = AssignResource((CSVDATA["SoundFile"]))
	pass

func AssignResource(ResourceType) -> Resource:
	if ResourceType.empty():
		return null
	else:
		return load(ResourceType)
	pass
