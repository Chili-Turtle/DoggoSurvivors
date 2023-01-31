extends ProjectileMovementForward

class_name ProjectileMovementWindScar

func _ready():
	pass

func velocity(projectile, delta, result) -> Vector2:
	var velocityMult : float
	if projectile.TravelTime < 0.5:
		velocityMult = min(projectile.TravelTime * 1.5, 2)
	else:
		velocityMult = 2
	return .velocity(projectile, delta, result) * velocityMult
	pass
