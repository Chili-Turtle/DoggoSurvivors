class_name Drops

extends Node # TIP Don't forget that resources store data globaly (so if add +1 to a var in the resource every other instance has also +1)

#var crystal = preload("res://Nodes/Gems/PickUp.tscn")
var crystal = preload("res://Nodes/Gems/PickUp.tscn")

func _ready():
	pass

func RollDrop(_owner):
	for i in range(0, (randi() % 3) + 1):
#			var expcrystal = crystal.instance()
			var pos = _owner.position + Vector2(rand_range(-20, 20), rand_range(-20, 20))
			var expcrystal = GameFunction.SpawnActor(crystal, pos, Vector2(1, 1), LevelManager.SpawnContainer,_owner.get_parent())
#			expcrystal.position = _owner.position + Vector2(rand_range(-20, 20), rand_range(-20, 20))
#			_owner.get_parent().add_child(expcrystal) # TODO make a level manager and have the ySort as reference
	pass
