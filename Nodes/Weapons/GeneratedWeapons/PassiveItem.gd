extends Node2D

export var CurStats : Resource = WeaponStats.new()

var BuffNode : Node2D
var BuffScript = preload("res://Nodes/State/ExtraDamageAreaBuff.gd")

var Instigator = null
#var CurBurstOffset : float = 0.0

func _ready():
	var sprite = Sprite.new()
	sprite.texture = load("res://icon.png")
	sprite.scale = Vector2(0.1,0.1) #DEPRICATED just a debug thing
	sprite.modulate = Color.darkviolet
	add_child(sprite)
	
	SpawnBuff()
	pass

func SpawnBuff(): #should that be in the player add buff?
	# mostly meat and potatoe ~mostly... SpawnNode2D and add script
	
#	PlayerManager.PlayerPawn.get_node("States").AddState("ExtraDamage")
	BuffNode = Node2D.new()
	BuffNode.set_script(BuffScript)
	PlayerManager.PlayerPawn.get_node("States").add_child(BuffNode)
	BuffNode.InitStateValues("ExtraDamage")
	BuffNode.owner = PlayerManager.PlayerPawn
	pass

func LevelUp():
	BuffNode.LevelUp()
	print("Updateing the Buff somehow")
	pass

# remove buff node
func RemoveBuff():
	PlayerManager.PlayerPawn.get_node("States").remove_child(BuffNode)
	pass
