class_name MoveDirection
extends SpawnDirection

export(GameFunction.ERotationDirection) var RotationDirection = GameFunction.ERotationDirection.Colckwise

func GetSpawnDirections(CommencedAttacks, _Instigator, _Entity = null) -> Vector2:
	return _Entity.velocity.normalized()
