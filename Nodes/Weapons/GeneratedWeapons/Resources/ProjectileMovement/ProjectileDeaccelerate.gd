extends ProjectileMovementBase

class_name ProjectileDeaccelerate

func _ready():
	pass

func velocity(projectile, delta, result) -> Vector2:
	var MoveDir = projectile.transform.x * projectile.DirectionSwitch
	var velocity = MoveDir * projectile.speed
	projectile.speed -= projectile.speed * delta * 2.0
	
	if !result.empty() and projectile.IgnoreAtStart.has(result[0].collider) == false:
		var direction = projectile.position - result[0].collider.position
		velocity = direction.normalized() * 100
		projectile.transform.x = projectile.transform.x.bounce(result[0].HitInfo.normal).normalized()
#		velocity = projectile.velocity.bounce(result[0].HitInfo.normal)
#		projectile.speed += 1000.0 * delta
		pass
	
	projectile.KnockBackMultiplier = min(1, projectile.velocity.length()/50)
	return velocity
	pass

