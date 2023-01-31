class_name OneEightySpawn
extends SpawnDirection

export(GameFunction.ERotationDirection) var RotationDirection = GameFunction.ERotationDirection.Colckwise
export(int, 1, 36) var  CirclePointsAmount = 3

var CurAngle = 0
# DEPRICATED is this depricated? -> var OffsetLength = Vector2()
var rotOffset = 0

func GetSpawnDirections(CommencedAttacks, _Instigator, _Entity = null) -> Vector2:
	if CommencedAttacks < 1: # Reset Angle/Offset
		GetInitSpawnDirection()
		# DEPRICATED ??? is this depricated -> OffsetLength = Vector2()
#		rotOffset = deg2rad(360)
		rotOffset = PlayerManager.PlayerPawn.position.angle_to_point(_Entity.position) - (PI/3)
#		OffsetLength = Vector2.RIGHT.angle_to_point(PlayerManager.PlayerPawn.position)
		CurAngle = 0

#	print(CommencedAttacks)
	# decide direction with comparison to the Right direction, and adding it to the CurAngle: 
	CurAngle *= RotationDirection # Clockwise/CounterClockwise
	# additvie the angel could change (rotation like)
	
	# 180 / 3 = step
	
	var step = ((PI / 2) / CirclePointsAmount) # FIXME //I have the wepon ref (so this does not apply)-> (FIXME: PASS THE PROJECTILEAMOUNT INTO THE FUNCTION) If the Attack Area stays always 90° the CirclePointAmount should be equal to ProjectileAmount
	CurAngle += step
#	CurAngle = (PI / CirclePointsAmount) * CommencedAttacks # seqeuncel (no reset needed)
	
	var CurCirclePoint = Vector2(cos(CurAngle + rotOffset), sin(CurAngle + rotOffset))
	#### decide direction other method (No Up/Down)
	# CurCirclePoint.x *= GetInitSpawnDirection().x

	return CurCirclePoint # DEPRICATED ??? is this depricated -> + OffsetLength
	pass

func GetInitSpawnDirection() -> Vector2:
	var PlayerPawn = PlayerManager.get_PlayerPawn()
	match PlayerPawn.PlayerMoveDir:
		GameFunction.E8WayDir.Left:
			return RemapInputDirToCustomDir(PlayerInputLeft)
			pass
		GameFunction.E8WayDir.Right:
			return RemapInputDirToCustomDir(PlayerInputRight)
			pass
		GameFunction.E8WayDir.Up:
			return RemapInputDirToCustomDir(PlayerInputUp)
			pass
		GameFunction.E8WayDir.Down:
			return RemapInputDirToCustomDir(PlayerInputDown)
			pass
		GameFunction.E8WayDir.DiagonalUp_Left:
			return RemapInputDirToCustomDir(PlayerInputDiagonalUp_Left)
			pass
		GameFunction.E8WayDir.DiagonalUp_Right:
			return RemapInputDirToCustomDir(PlayerInputDiagonalUp_Right)
			pass
		GameFunction.E8WayDir.DiagonalDown_Left:
			return RemapInputDirToCustomDir(PlayerInputDiagonalDown_Left)
			pass
		GameFunction.E8WayDir.DiagonalDown_Right:
			return RemapInputDirToCustomDir(PlayerInputDiagonalDiagonalDown_Right)
			pass
		_:
			return Vector2()
			pass
	pass
