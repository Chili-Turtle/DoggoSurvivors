extends ProjectileMovementBase

class_name ProjectileMovementForward

func _ready():
	pass

func velocity(projectile, delta, result) -> Vector2:
	var MoveDir = projectile.transform.x * projectile.DirectionSwitch
	var velocity = MoveDir * projectile.speed
	return velocity
	pass
