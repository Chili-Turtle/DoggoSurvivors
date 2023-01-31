class_name WhipSpawnDirection
extends SpawnDirection

export(GameFunction.ERotationDirection) var RotationDirection = GameFunction.ERotationDirection.Colckwise
export(int, 1, 36) var  CirclePointsAmount = 4

var CurAngle = 0
var OffsetLength = Vector2()
var InitSpawn = 0# Vector2()

func GetSpawnDirections(CommencedAttacks, _Instigator, _Entity = null) -> Vector2:
	if CommencedAttacks < 1: # Reset Angle/Offset
#		InitSpawn = GetInitSpawnDirection().angle() # with this you can aim down other wise use below
#		InitSpawn = GetInitSpawnDirection().x # use "+ acos(InitSpawn)" in [0,1] CommencedAttack
		OffsetLength = Vector2()
		CurAngle = 0
	
	# you could also use -> CommencedAttacks
	CurAngle = ((2*PI / CirclePointsAmount) * 0) + GetInitSpawnDirection().angle() # + acos(InitSpawn) # seqeuncel (no reset needed)
	
########## Additive solution ############################
#	if CommencedAttacks == 1:
#		CurAngle += deg2rad(180)
#	elif CommencedAttacks >= 2:
#		CurAngle += deg2rad(-90) * InitSpawn.x
#		OffsetLength += Vector2(0, -0.4)
########## fixed solution ############################
	if CommencedAttacks == 1:
		CurAngle = ((2*PI / CirclePointsAmount) * 2) + GetInitSpawnDirection().angle() #acos(InitSpawn)
	elif CommencedAttacks >= 2:
		CurAngle = ((2*PI / CirclePointsAmount) * 3)
		OffsetLength += Vector2(0, -0.4)
########## Hardcoded solution ############################

	CurAngle *= RotationDirection # Clockwise/CounterClockwise
	
	var CurCirclePoint = Vector2(cos(CurAngle), sin(CurAngle))
	return CurCirclePoint + OffsetLength
	pass


