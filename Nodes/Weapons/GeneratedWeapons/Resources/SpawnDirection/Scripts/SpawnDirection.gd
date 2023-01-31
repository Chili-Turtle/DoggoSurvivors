class_name SpawnDirection
extends Resource

export(GameFunction.E8WayDir) var PlayerInputLeft = GameFunction.E8WayDir.Left
export(GameFunction.E8WayDir) var PlayerInputRight = GameFunction.E8WayDir.Right
export(GameFunction.E8WayDir) var PlayerInputUp = GameFunction.E8WayDir.Up
export(GameFunction.E8WayDir) var PlayerInputDown = GameFunction.E8WayDir.Down
export(GameFunction.E8WayDir) var PlayerInputDiagonalUp_Left = GameFunction.E8WayDir.DiagonalUp_Left
export(GameFunction.E8WayDir) var PlayerInputDiagonalUp_Right = GameFunction.E8WayDir.DiagonalUp_Right
export(GameFunction.E8WayDir) var PlayerInputDiagonalDown_Left = GameFunction.E8WayDir.DiagonalDown_Left
export(GameFunction.E8WayDir) var PlayerInputDiagonalDiagonalDown_Right = GameFunction.E8WayDir.DiagonalDown_Right

# instigator == ProjectileSpawner
func GetSpawnDirections(CommencedAttacks, _Instigator, _Entity = null) -> Vector2:
	return GetInitSpawnDirection()
	pass

func RemapInputDirToCustomDir(DirectionIndex) -> Vector2: # Remap the current player direction to a custom direction map, for example: If the player direction is left, you can remap the direction, so the weapon shoots to the right
	match DirectionIndex:
		GameFunction.E8WayDir.Left:
			return Vector2.LEFT
		GameFunction.E8WayDir.Right:
			return Vector2.RIGHT
		GameFunction.E8WayDir.Up:
			return Vector2.UP
		GameFunction.E8WayDir.Down:
			return Vector2.DOWN
		GameFunction.E8WayDir.DiagonalUp_Left:
			return Vector2(-1, -1)
		GameFunction.E8WayDir.DiagonalUp_Right:
			return Vector2(1, -1)
		GameFunction.E8WayDir.DiagonalDown_Left:
			return Vector2(-1, 1)
		GameFunction.E8WayDir.DiagonalDown_Right:
			return Vector2(1, 1)
		_:
			return Vector2(0, 0)
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

# why is this here? Can I delete this?
#func OverrideDefaultInputMap(_Left, _Right, _Up, _Down, _DiagonalUp_Left, _DiagonalUp_Right, _DiagonalDown_Left, _DiagonalDown_Right): # override the Remaped
#	PlayerInputLeft = _Left
#	PlayerInputRight = _Right
#	PlayerInputUp = _Up
#	PlayerInputDown = _Down
#	PlayerInputDiagonalUp_Left = _DiagonalUp_Left
#	PlayerInputDiagonalUp_Right = _DiagonalUp_Right
#	PlayerInputDiagonalDown_Left = _DiagonalDown_Left
#	PlayerInputDiagonalDiagonalDown_Right = _DiagonalDown_Right
#	pass
