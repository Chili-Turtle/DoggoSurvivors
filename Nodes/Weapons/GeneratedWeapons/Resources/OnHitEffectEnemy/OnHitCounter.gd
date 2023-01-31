class_name OnHitCounter
extends OnHitEffectBase
func _init():
	ItemName = "OnHitCounter"

func OnHit(HitObject, ObjectToSpawn, _Parent, _position, _InitDirection, Instigator):
	
	if ObjectToSpawn.Contact >= ObjectToSpawn.MaxCountactAmount:
		ObjectToSpawn.get_parent().remove_child(ObjectToSpawn)
#		ObjectToSpawn.queue_free()
		pass
	pass
