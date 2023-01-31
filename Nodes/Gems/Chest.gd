extends Area2D

var AnimPlayer = AnimationPlayer.new()

var is_picked_up = false
var AnimationPath_part1 # if sprite has animation
var AnimationPath_part2 = preload("res://Sprite/Chest/ChestOpen2.anim") # FIXME this should be in the csv data stuff but I am not certain if I even use csv anymore
var SoundFile
var Value

var ChestGUI = preload("res://Nodes/Widget/ChestWidget.tscn").instance()

func _ready():
	InitData("Chest")
	
	add_child(AnimPlayer)
	AnimPlayer.connect("animation_finished", self, "OnAnimationFinished")
	set_process(false)
	pass

func OnStartPickUp():
	if is_instance_valid(PlayerManager.PlayerPawn) and is_picked_up == false:
		is_picked_up = true
		AnimPlayer.add_animation("ChestOpen1", AnimationPath_part1)
		AnimPlayer.add_animation("ChestOpen2", AnimationPath_part2)
		AnimPlayer.play("ChestOpen1")
	pass

func OnAnimationFinished(AnimationName):
	if AnimationName == "ChestOpen1":
		OnPickUp()
		AnimPlayer.play("ChestOpen2")
	else:
		queue_free()
		pass
	pass

func OnPickUp():
	if is_instance_valid(self):
		print("add player coins + 100")
		# FIXME Make a global ui manage
		UiManager.AddUI(ChestGUI, true) # TODO Make a global ui manage
	pass

func _on_Chest_body_entered(body):
	if body == PlayerManager.PlayerPawn:
		OnStartPickUp()
	pass


func InitData(PickUpName : String):
	var CSVDATA = GameFunction.readCSV("res://Data/PickUpItems.csv")
	$Sprite.texture = AssignResource(CSVDATA[PickUpName]["TexturePath"])
	$Sprite.hframes = int(CSVDATA[PickUpName]["hframes"])
	$Sprite.vframes = int(CSVDATA[PickUpName]["vframes"])
	$Sprite.frame = int(CSVDATA[PickUpName]["Curframe"])
	Value =  float(CSVDATA[PickUpName]["Value"])
	AnimationPath_part1 = AssignResource(CSVDATA[PickUpName]["AnimationPath"])
	SoundFile = AssignResource((CSVDATA[PickUpName]["SoundFile"]))
	pass

func AssignResource(ResourceType) -> Resource:
	if ResourceType.empty():
		return null
	else:
		return load(ResourceType)
	pass
