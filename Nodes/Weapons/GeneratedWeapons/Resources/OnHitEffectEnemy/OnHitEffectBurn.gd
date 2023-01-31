class_name OnHitEffectBurn
extends OnHitEffectBase

var BurnScript = preload("res://Nodes/State/BurnState.gd")

func _init():
	ItemName = "OnHitEffectBurn"

func OnHit(HitObject, ObjectToSpawn, _Parent, _position, _InitDirection, _Instigator):
	
	for child in HitObject.collider.get_children():
		if child.get_script() != null:
			if child.get_script().resource_path.get_file() == "StateManger.gd": #or get_path() for resource_path # child.get_class(), is_class("Node2D")
				var Buffnode = Node2D.new()
				Buffnode.set_script(BurnScript)
				child.AddState(Buffnode)
		pass
	
#	if HitObject.collider.has_node("State"):
#		HitObject.collider.get_node("State").AddState("BurningState")
		pass
	pass
