extends ProjectileMovementBase

class_name ProjectileMovementForwardHoming

func _ready():
	pass

# FIXME This just target the player, have a targetlist in the projectile and a IsInAir Resource with Targeting cast which scans fortargets from the mask
func velocity(projectile, delta, result) -> Vector2:

	if projectile.TravelTime > 0.3:
		var DirectionToPlayer = projectile.position.direction_to(PlayerManager.PlayerPawn.position)
		var RotationStep = projectile.transform.x.cross(DirectionToPlayer.normalized())
		projectile.rotation += RotationStep * projectile.get_process_delta_time() * 1.5
		

	var MoveDir = projectile.transform.x * projectile.DirectionSwitch
	var velocity = MoveDir * projectile.speed
	return velocity
	pass
