extends Node

const Bullet := preload("res://Nodes/Weapons/Projectiles/Projectile.tscn")

var pool_size := 300

var _pool := []
var index := -1

func _ready():
	for i in pool_size:
		var bullet = Bullet.instance()
		_pool.append(bullet)
	pass
# (InstancePackedScene, _positon = Vector2(0, 0), _rotation = 0, _scale = Vector2(1, 1), _parent = null, _owner = null) -> PackedScene:
func GetNextBullet(_positon, _rotation, _scale, _parent, _owner):
	index = (index + 1) % pool_size
	
#	_pool[index]
#	print(index) # DEBUG Print the index of pooled object

	# if this happends that mostly means that you have to increase the pool size, because it took a projectile which is currently used
	if is_instance_valid(_pool[index]):
		if _pool[index].get_parent(): # -> you also could use "is_inside_tree()" to check if still has a parent
			printerr("bullet still has parent")
			_pool[index].get_parent().remove_child(_pool[index])
	
		# this was just needed because I set the bullets as top level, Readmore: https://github.com/godotengine/godot/issues/24154
		_pool[index].position = _positon
	#	_pool[index].position = Vector2() #resets the position
	#	_pool[index].scale = _scale
		_parent.add_child(_pool[index])
		_pool[index].owner = _owner #owner has to be set after add child
	
	return _pool[index]
	pass
