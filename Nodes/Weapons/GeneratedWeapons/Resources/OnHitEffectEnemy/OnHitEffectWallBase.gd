class_name OnHitEffectWallBase
extends Resource

var ItemName = ""

func OnHit(HitObject, ObjectToSpawn, _Parent, _position, _InitDirection, _Instigator):
	ItemName = "OnHitEffectWallBase"
	var direction = HitObject - _position
	direction = direction.normalized()
	_Instigator.position += direction
	pass

func LevelUp():
	pass
