extends Node2D

onready var WeaponCoolDown = get_node("%WeaponCoolDown")
onready var AttackCast = get_node("AttackCast")
onready var WhipTimer = $WhipTimer

var Disabled = false

var InitSpawnDirection : Vector2 = Vector2.RIGHT
var OffsetLength = Vector2(0.0, 0.0)

export var HitBox = Vector2(50, 20)
var ProjectileAmount = 4
var ProjectileDistriputionAmount = 4 # This is the distripution of the spawn places 4 means, left, right, up, down

var angle = 0
var angle_step = 0
var direction = 0

var CommencedAttacks : int = 0

var spriteResource = preload("res://Sprite/Animations/Whipe normal animation.tres")

var SoundFile = preload("res://Sounds/sfx/WhipSlash/JumpKing jump 2.wav")

# run the attack once, after this run it times -1 

func _ready():
	WeaponCoolDown.connect("timeout", self, "OnWeaponCoolDownTimeout")
	WhipTimer.connect("timeout", self, "OnWhipTimerTimeout")
	pass

func OnWeaponCoolDownTimeout():
#	WhipTimer.start()
	#SpawnHitBoxes()
	iteration_of_attacks()
	pass

func OnWhipTimerTimeout():
	if CommencedAttacks >= ProjectileAmount:
		CommencedAttacks = 0
		WhipTimer.stop()
		WeaponCoolDown.start()
		get_node("AnimatedSprite").visible = false
	else:
		iteration_of_attacks()
	pass

func GetCircle(_segments : int):
	#Vector2().rotated()
	var center = Vector2() # Vector2(owner.position)
	var radius = 25
	angle_step = 2*PI / ProjectileDistriputionAmount # deg2rad(360) // 2*PI == 2*180 = 360
	direction = Vector2(cos(angle), sin(angle))
	direction.x *= InitSpawnDirection.x
	var pos = center + direction * radius
	return pos
	pass

func SpawnHitBoxes(): # attack pattern
	SetSpawnDirection()
	
	#OffsetLength = HitBox.x + 5
	
	# get start direction
	# how do I call the whip base attack, start (I = 1), the opposite (I = 2), then the top (I = 3), then the top with offset(I = 4)
	
	
	for i in range(0, ProjectileAmount):
		angle = (2*PI / ProjectileDistriputionAmount) * i # add the next 
		#angle += angle_step
		
		# add a sprite dymanicly
#		var graphic = AnimatedSprite.new()
#		graphic.frames = spriteResource
#		graphic.play("idle")
#		graphic.position = Vector2()
#		graphic.scale = HitBox * 0.08
#		add_child(graphic)
		
		# special cases for iterations
		if i >= 1:
			angle = (2*PI / ProjectileDistriputionAmount) * (i + 1)

		if i >= 3:
			angle = (2*PI / ProjectileDistriputionAmount) * 3.0
			OffsetLength += Vector2.UP * 20.0
		
#		$WhipTimer.start(0.2)
		var HitResult = AttackCast.MultiRectangleCast(owner.position + GetCircle(i) + OffsetLength + Vector2(HitBox.x * 0.5 * direction.x, 0), HitBox)
		get_node("AnimatedSprite").position = owner.position + GetCircle(i) + OffsetLength
		get_node("AnimatedSprite").visible = true #HitBox = Vector2(20, 5)
		get_node("AnimatedSprite").scale = HitBox * 0.08
		SoundManager.PlaySound(SoundFile)
		
		if HitResult.size() != 0:
			for hit in HitResult:
				if is_instance_valid(hit.collider):
#					hit.collider.get_node("Stats/Health").TakeDamage(self, 50.0)
					pass
					
#		yielder = yield(get_tree().create_timer(0.2), "timeout")

	#get_node("AnimatedSprite").visible = false
	angle = 0 #reset the angle
	OffsetLength = Vector2() #reset tge offset
	pass

func OnAnimationFinished():
	get_node("AnimatedSprite").visible = false
	pass

func iteration_of_attacks():
	SetSpawnDirection()
	angle = (2*PI / ProjectileDistriputionAmount) * CommencedAttacks # add the next
	
	# special cases for iterations
	if CommencedAttacks >= 1:
		angle = (2*PI / ProjectileDistriputionAmount) * (CommencedAttacks + 1)

	if CommencedAttacks >= 3:
		angle = (2*PI / ProjectileDistriputionAmount) * 3.0
		OffsetLength += Vector2.UP * 20.0

	# this is the Attack type
	var HitResult = AttackCast.MultiRectangleCast(owner.position + GetCircle(CommencedAttacks) + OffsetLength + Vector2(HitBox.x * 0.5 * direction.x, 0), HitBox)
	get_node("AnimatedSprite").position = owner.position + GetCircle(CommencedAttacks) + OffsetLength
	get_node("AnimatedSprite").visible = true #HitBox = Vector2(20, 5)
	get_node("AnimatedSprite").scale = HitBox * 0.08
	SoundManager.PlaySound(SoundFile)

	if HitResult.size() != 0:
		for hit in HitResult:
			if is_instance_valid(hit.collider):
				if is_instance_valid(hit.collider):
					hit.collider.get_node("Stats/Health").TakeDamage(self, 50.0)
#					hit.collider.KnockBack()
					pass

	# get_node("AnimatedSprite").visible = false
	# angle = 0 #reset the angle
	OffsetLength = Vector2() #reset tge offset
	CommencedAttacks += 1
	WhipTimer.start()

func SetSpawnDirection():
	match owner.PlayerMoveDir:
		owner.MoveDir.Left:
			InitSpawnDirection = Vector2.LEFT
			pass
		owner.MoveDir.Right:
			InitSpawnDirection = Vector2.RIGHT
			pass
		owner.MoveDir.Up:
			#print("Spawn Up")
			pass
		owner.MoveDir.Down:
			#print("Spawn Down")
			pass
		owner.MoveDir.DiagonalUp_Left:
			#print("Spawn DiagonalUp_Left")
			InitSpawnDirection = Vector2.LEFT
			pass
		owner.MoveDir.DiagonalUp_Right:
			#print("Spawn DiagonalUp_Right")
			InitSpawnDirection = Vector2.RIGHT
			pass
		owner.MoveDir.DiagonalDown_Left:
			#print("Spawn DiagonalDown_Left")
			InitSpawnDirection = Vector2.LEFT
			pass
		owner.MoveDir.DiagonalDown_Right:
			#print("Spawn DiagonalDown_Right")
			InitSpawnDirection = Vector2.RIGHT
			pass
		_:
			pass
	pass
