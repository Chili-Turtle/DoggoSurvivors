extends Node2D

# DEPRICATED This actually works but is depricated for ProjectileSpanwer.gd, Because this has a timer node and timer sapzzing around if time is less then 0.05

export var CurStats : Resource = WeaponStats.new()
#var WeaponStatsScript = preload("res://Data/Resources/WeaponStats.gd")

# variables
var InitSpawnDirection : Vector2 = Vector2.RIGHT
var CommencedAttacks : int = 0
var ProjectileIntervalTimer : float = 0.0
var is_Oneshot = false

func _ready():
	
	# DEPRICATED pls delete if you have no projectile spawning x--> (that suppose to be an arrow/error)
	# Spawn a new resource, and assign script
#	var WeaponStatsResource = Resource.new()
#	WeaponStatsResource.script = WeaponStatsScript
#	CurStats = WeaponStatsResource
	
	set_process(false)
	$WeaponCoolDown.connect("timeout", self, "OnWeaponCoolDownTimeout")
	pass

# Signal
func OnWeaponCoolDownTimeout():
	StartAttack()
	pass

func StartAttack():
	if CommencedAttacks >= CurStats.ProjectileAmount:
		if is_Oneshot == true:
			queue_free()
			return

		$WeaponCoolDown.start()
		set_process(false) #stops the between time and set it to 0.0
		CommencedAttacks = 0
		ProjectileIntervalTimer = 0.0
	else:
		InitAttack()
	pass

func _process(delta):
	ProjectileIntervalTimer += delta #between timer (FAQ: Why not using Timer: So I can Between timer under 0.05 sec)

	if ProjectileIntervalTimer > CurStats.ProjectileInterval:
		StartAttack()
	pass

func InitAttack():
	# Spawn direction
	InitSpawnDirection = CurStats.SpawnerDirecton.GetSpawnDirections(CommencedAttacks) #(1, 0)
#	InitSpawnDirection = PlayerManager.PlayerPawn.WeaponDirection # TIP For Slerping Weapon rotation

	# Spawn Projectile
	var NewProjectile = GameFunction.SpawnActor(CurStats.ProjectileType.projectile, to_global(position), 0, Vector2(1, 1), LevelManager.GetSpawnContainer(), PlayerManager.PlayerPawn)

	# Calc Position
	var ProjectilePosition =  -(InitSpawnDirection * CurStats.SpawnOffset) + Vector2(rand_range(-CurStats.RandSpawnRadius, CurStats.RandSpawnRadius), rand_range(-CurStats.RandSpawnRadius, CurStats.RandSpawnRadius)) # owner because weapons are on Vector2(0, 0)

	# Add the player values
	NewProjectile.AssignData(CurStats.ProjectileSpeed, InitSpawnDirection, CurStats.SpriteResource, CurStats.Damage, CurStats.CollisionArea, CurStats.MaxRange, CurStats.KnockbackAmount, ProjectilePosition, CurStats.OnHitEffectEnemie, CurStats.OnHitEffectWall) # FIXME Shoot

	# Assign Sound
	SoundManager.PlaySound(CurStats.SoundFile, -15, rand_range(0.9, 1.1))
	set_process(true)
	CommencedAttacks += 1
	ProjectileIntervalTimer = 0.0
	pass
