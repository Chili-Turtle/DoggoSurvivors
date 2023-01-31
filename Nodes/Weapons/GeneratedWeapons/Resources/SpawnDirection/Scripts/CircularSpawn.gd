class_name CircularSpawn
extends SpawnDirection

export(GameFunction.ERotationDirection) var RotationDirection = GameFunction.ERotationDirection.Colckwise
export(int, 1, 36) var  CirclePointsAmount = 4

var CurAngle = 0
var OffsetLength = Vector2()

func GetSpawnDirections(CommencedAttacks, _Instigator, _Entity = null) -> Vector2:
	if CommencedAttacks < 1: # Reset Angle/Offset
		GetInitSpawnDirection()
#		OffsetLength = Vector2()
		CurAngle = 0

	var BurstOffset = deg2rad(_Instigator.CurBurstOffset)
	# decide direction with comparison to the Right direction, and adding it to the CurAngle: 
	CurAngle *= RotationDirection # Clockwise/CounterClockwise
#	CurAngle += (2*PI / CirclePointsAmount) # Additve bugs-out sometimes, where it does a angle 2 times
	CurAngle = (2*PI / CirclePointsAmount) * CommencedAttacks # seqeuncel (no reset needed)

	# additional things 1
	
	var CurCirclePoint = Vector2(cos(CurAngle + BurstOffset), sin(CurAngle + BurstOffset))
	#### decide direction other method (No Up/Down)
	# CurCirclePoint.x *= GetInitSpawnDirection().x

	return CurCirclePoint # + OffsetLength
	pass
