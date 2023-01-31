extends Node2D

# class_name TODO, Decide a classname

export var CurStats : Resource = WeaponStats.new()
# DEPRICATED var WeaponStatsScript = preload("res://Data/Resources/WeaponStats.gd")
var CommencedAttacks = 0

var ProjectileIntervalTimer  : float = 0.0
var WeaponCoolDownTimer : float = 0.0 #just a timer to compare the WeaponStat CooldownTimer, if I would subract the timer I could just compare to 0
var IsOneshot = false
var IsInAttackLoop = false
var Instigator = null
var CurBurstAmount = 0
var BurstCoolDownTimer : float = 0.0
var CurBurstOffset : float = 0.0

var ProjectileList : Array # Collectes all the Projectile from One Shoot cycle, then clears the array

signal AttackFinished()

# Creates Stats resource/assigns resources
func CreateResource():
	# Spawn a new resource, and assign script
#	# DEPRICATED var WeaponStatsResource = WeaponStats.new() #TODO Replace it With WeaponStatsResource.new(), some scripts have the old method ->Resource.new, WeaponStatsResource.script = WeaponStatsScript
#	CurStats = WeaponStatsResource
	pass

# upgrades the stats and the buff data
func LevelUp():
	CurStats.UpgradeWeapon()
	pass

func SpawnBuff():
	print("do Some buff stuff, larry face")
	pass

func _ready():
	# DEPRICATED CreateResource()

	# DEPRICATED Just a debug thing (adds a sprite to the weapon position)
#	var sprite = Sprite.new()
#	sprite.texture = load("res://icon.png")
#	sprite.scale = Vector2(0.1,0.1) #DEPRICATED just a debug thing
#	sprite.modulate = Color.darkviolet
#	add_child(sprite)
	pass

func Set_Active(_active):
	match _active:
		true:
			set_process(true)
		false:
			set_process(false)
	pass

func _process(delta):
	if IsInAttackLoop == true:
		ProjectileIntervalTimer += delta # TIP I could use just the gametimer and pocket the time difference, rather then having 3 seperated times
		if ProjectileIntervalTimer >= CurStats.ProjectileInterval:
			StartAttack()
		return

	# this just runs if attackloop is false(^return)
	# If this is the 2nd Burst wave... else
	if CurBurstAmount > 0:
		BurstCoolDownTimer += delta

		if BurstCoolDownTimer >= CurStats.BurstCooldown:
			StartAttack()
			IsInAttackLoop = true
			BurstCoolDownTimer = 0.0
	else: # if 1st burst wave
		WeaponCoolDownTimer += delta
		if WeaponCoolDownTimer >= CurStats.GetCooldown():
			StartAttack()
			IsInAttackLoop = true
			WeaponCoolDownTimer = 0.0
			pass
	
	pass

# Description, StartAttack() is the function which controlles the projectile spawning, and checks if the weapon is done spawning 
# Don't forget this is run in process, so no loops, just checks
func StartAttack():
#	InitProjectiles()
	
	# ------------------- WaitTime for SpawnProjecitles ------------------- super clunky tho
	# -> Delete ProjectileIntervalTimer in InitProjectiles()
	# -> InitProjectiles() should be in an if statement like this 
	if CommencedAttacks < CurStats.GetProjectileAmount():
		InitProjectiles()
	# I just abuse the ProjecitleIntervalTimer, so I don't have to do another timer
	if ProjectileIntervalTimer <= CurStats.ShootDelay and CurBurstAmount < 1:
		return
#	ProjectileIntervalTimer = 0.0
# ------------------- WaitTime for SpawnProjecitles -------------------

	# if all projectile have spawned
	if CommencedAttacks >= CurStats.GetProjectileAmount():
		for projectile in ProjectileList:
			if is_instance_valid(projectile):
				projectile.HasStarted = true
				pass

		CurBurstAmount += 1
		ProjectileList.clear()
		IsInAttackLoop = false
		CommencedAttacks = 0
		ProjectileIntervalTimer = 0.0
		
		if CurBurstAmount >= CurStats.BurstAmount:
			CurBurstAmount = 0
			emit_signal("AttackFinished") # used for enemie attack, and weapons, where all the bullets has to spawn in before doing stuff
			if CurStats.OneShot == true:
				ProjectileList.clear()
				queue_free()
				return

	pass

# Description Inits projectile
func InitProjectiles():
	CurBurstOffset = CurStats.BurstOffset[CurBurstAmount % CurStats.BurstOffset.size()]
	var InitSpawnDirection = CurStats.SpawnerDirecton.GetSpawnDirections(CommencedAttacks, self, owner)
	# Spawn Projectile
	
#	var NewProjectile = GameFunction.SpawnActor(CurStats.ProjectileType, to_global(Vector2()), 0, Vector2(1, 1), LevelManager.GetSpawnContainer(), LevelManager.GetSpawnContainer())

	# spawn projectile over pool #DEBUG
	var NewProjectile : Node2D
	if CurStats.AttachedAtStart == true:
		NewProjectile = Pool.GetNextBullet(Vector2(), 0, Vector2(1, 1), self, self)
	else:
		# Not attached to the player
		NewProjectile = Pool.GetNextBullet(to_global(Vector2()), 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer)
		

	# Pls send help, Debugs the relation of position, now it wroks :)
#	if CurStats.ItemName == "OnHitSpikes":
#		printerr("--> Spawner Pos %d %d" %[position.x, position.y])
#		printerr("--> Global Pos %d %d" %[to_global(position).x, to_global(position).y])
#		printerr("--> Global Pos %d %d" %[to_global(Vector2()).x, to_global(Vector2()).y])
#		printerr("--> Global Pos %d %d" %[Vector2().x, Vector2().y])
#		pass
#	else:
#		print("--> Spawner Pos %d %d" %[position.x, position.y])
#		print("--> Global Pos %d %d" %[to_global(position).x, to_global(position).y])
#		print("--> Global Pos %d %d" %[to_global(Vector2()).x, to_global(Vector2()).y])
#		print("--> Global Pos %d %d" %[Vector2().x, Vector2().y])
#		pass

	# Calc Offset ^ Put this first
#	var ProjectileOffset = owner.position - (InitSpawnDirection * CurStats.SpawnOffset) + Vector2(rand_range(-CurStats.RandSpawnRadius, CurStats.RandSpawnRadius), rand_range(-CurStats.RandSpawnRadius, CurStats.RandSpawnRadius)) # owner because weapons are on Vector2(0, 0)
#	var ProjectileOffset =  Vector2()
	var ProjectileOffset =  -(InitSpawnDirection * CurStats.SpawnOffset) + Vector2(rand_range(-CurStats.RandSpawnRadius, CurStats.RandSpawnRadius), rand_range(-CurStats.RandSpawnRadius, CurStats.RandSpawnRadius)) # owner because weapons are on Vector2(0, 0)
	
	# MultipliedStats
	if is_instance_valid(NewProjectile):
		NewProjectile.AssignData(CurStats.GetProjectileSpeed(), InitSpawnDirection, CurStats.SpriteResource, CurStats.GetDamage(), CurStats.GetCollisionArea(), CurStats.GetMaxRange(), CurStats.GetKnockBackAmount(), ProjectileOffset, CurStats.OnHitEffectEnemie, CurStats.OnHitEffectWall, CurStats.ScaleMultiplier, CurStats.HasInitRotation, CurStats.SpriteRotation, Instigator, CurStats.CollisionMask, CurStats.ProjectileMovement, CurStats.AutoStartProjectile, CurStats.MaxAirTime, CurStats.OnAirTimeEndArray, CurStats.OnWeaponAnimationFinished, CurStats.KnockBackCenterProjectile) # FIXME Shoot
		ProjectileList.append(NewProjectile)

	CommencedAttacks += 1
	ProjectileIntervalTimer = 0.0
	pass
