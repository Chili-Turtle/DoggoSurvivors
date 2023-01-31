#extends Node2D
#
#onready var WeaponCoolDown = get_node("%WeaponCoolDown")
#
#var Disabled = false
#
## stats variables
#var SpawnRadius = 6.0
#export var HitBox = Vector2(50, 20)
#var CollisionRadius = 1.0
#var ProjectileAmount = 1
#var Damage = 0.0
#var CoolDown = 10.0
#var ProjectileInterval : float = 0.1
#var KnockbackAmount = -100
#var ProjectileSpeed = 40.0
#var MaxRange = 100.0
## resources/sprite
#var projectile = preload("res://Nodes/Weapons/Projectiles/Projectile.tscn")
#var SpriteResource = preload("res://Sprite/Swords/sword_02.png")
#var SoundFile = preload("res://Sounds/sfx/Knife/Weapons, Sword, Swing, whoosh 03.wav")
#
## hard stats
#var InitSpawnDirection : Vector2 = Vector2.RIGHT
#var ProjectileIntervalTimer : float = 0.0
#var CommencedAttacks : int = 0
#
## not needed stats (probably for circle spawn)
#var OffsetLength = Vector2(0.0, 0.0)
#var ProjectileDistriputionAmount = 4 # This is the distripution of the spawn places 4 means, left, right, up, down
#var angle = 0
#var angle_step = 0
## var direction := Vector2() # do I use that?
#
#func AssignBaseStats(_WeaponName):
#	var BaseStats : Dictionary = GameFunction.readCSV("res://Data/WeaponData.csv")
#	ProjectileAmount = int(BaseStats[_WeaponName]["Amount"])
#	ProjectileInterval = float(BaseStats[_WeaponName]["ProjectileInterval"])
#	Damage = float(BaseStats[_WeaponName]["BaseDamage"])
#	KnockbackAmount = float(BaseStats[_WeaponName]["Knockback"])
#	CoolDown = float(BaseStats[_WeaponName]["Cooldown"])
#	ProjectileSpeed = float(BaseStats[_WeaponName]["ProjectileSpeed"])
#	MaxRange = float(BaseStats[_WeaponName]["MaxRange"])
#	CollisionRadius = float(BaseStats[_WeaponName]["CollisionRadius"])
#	pass
#
#func _ready():
#	AssignBaseStats("Knife")
#
#	set_process(false)
#	WeaponCoolDown.connect("timeout", self, "OnWeaponCoolDownTimeout")
#	pass
#
## Start Attack
#func OnWeaponCoolDownTimeout():
#	StartAttack()
#	pass
#
#func StartAttack():
#	if CommencedAttacks >= ProjectileAmount:
#		WeaponCoolDown.start()
#		set_process(false) #stops the between time and set it to 0.0
#		CommencedAttacks = 0
#		ProjectileIntervalTimer = 0.0
#	else:
#		InitAttack()
#	pass
#
## Spawn attack projectile/Cast
#func InitAttack():
#	InitSpawnDirection = GetInitSpawnDirection()
#	var NewProjectile = projectile.instance()
#	add_child(NewProjectile)
#	NewProjectile.Shoot(ProjectileSpeed, InitSpawnDirection, SpriteResource, Damage, CollisionRadius, MaxRange, KnockbackAmount) #speed is in the resource
#	NewProjectile.position = owner.position - InitSpawnDirection * SpawnRadius + Vector2(rand_range(-SpawnRadius, SpawnRadius), rand_range(-SpawnRadius, SpawnRadius))
#	SoundManager.PlaySound(SoundFile, -15, rand_range(0.9, 1.1))
#	set_process(true)
#	CommencedAttacks += 1
#	ProjectileIntervalTimer = 0.0
#	pass
#
#func _process(delta):
#	ProjectileIntervalTimer += delta #between timer (FAQ: Why not using Timer: So I can Between timer under 0.05 sec)
#
#	if ProjectileIntervalTimer > ProjectileInterval:
#		StartAttack()
#	pass
#
## Get spawn direction
#func GetInitSpawnDirection() -> Vector2 :
#	match owner.PlayerMoveDir:
#		owner.MoveDir.Left:
#			return Vector2.LEFT
#			pass
#		owner.MoveDir.Right:
#			return Vector2.RIGHT
#			pass
#		owner.MoveDir.Up:
#			return Vector2.UP
#			pass
#		owner.MoveDir.Down:
#			return Vector2.DOWN
#			pass
#		owner.MoveDir.DiagonalUp_Left:
#			return Vector2(-1, -1)
#			pass
#		owner.MoveDir.DiagonalUp_Right:
#			return Vector2(1, -1)
#			pass
#		owner.MoveDir.DiagonalDown_Left:
#			return Vector2(-1, 1)
#			pass
#		owner.MoveDir.DiagonalDown_Right:
#			return Vector2(1, 1)
#			pass
#		_:
#			return Vector2()
#			pass
#	pass
#
#func OnAnimationFinished():
#	get_node("AnimatedSprite").visible = false
#	pass
