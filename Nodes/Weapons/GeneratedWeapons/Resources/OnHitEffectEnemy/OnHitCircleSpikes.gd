class_name OnHitCircleSpikes
extends OnHitEffectBase

# Stats
var ProjectileAmount = 4
var Damage = 0.0
var ProjectileSpeed = 20.0
var direction = Vector2()
var texture = null
var damage = 10.0
var CollisionArea = 100
var MaxRange = 1000
var KnockbackAmount = -100
var ProjectilePosition = Vector2()
var OnHitEffectEnemie : Array = []
var OnHitEffectWall : Array = []
var SoundFile = null
var RandSpawnRadius = 0.0
var SpawnOffset = 0.0

# Resources
var SpawnerDirecton = null
var ProjectileType = null
var SpriteResource = null

# not needed Stats
var CoolDown = 1.0
var ProjectileInterval = 0.0

# HACKED CHANGE THIS (loop with LevelIndex to LevelUpweapon before I shoot)
var LevelIndex = 0
func LevelUp():
	LevelIndex += 1
	pass

func _init():
	ItemName = "OnHitCircleSpikes"

func SpawnNewWeapon(_position, _Instigator):
#	var CSVDATA = GameFunction.readCSV(DataPath.GetItemData())
	var CSVDATA
	for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		pass
	var Weapon = GameFunction.SpawnActor(load("res://Nodes/Weapons/GeneratedWeapons/ProjectileSpawner.tscn"), _position, 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer) # FIXME This is plane Weird should a onhit effect be a weapon/projectile
	Weapon.Instigator = _Instigator
	Weapon.CurStats.AssignBaseStats("OnHitSpikes", false)
	
	# Hacked I level up the Weapon before I shoot
	for i in range(0, LevelIndex):
		Weapon.LevelUp()
		pass
	pass

func AddWeapon(_parent, WeaponName : String, _position, _InitDirection, _Instigator):
#	var CSVDATA = GameFunction.readCSV(DataPath.ItemData)
#	var Weapon = load(CSVDATA[WeaponName]["ItemPath"]).instance()
#	_parent.get_tree().root.get_viewport().add_child(Weapon)
##	_parent.get_parent().add_child(Weapon)
#	Weapon.owner = _parent.owner
##	Weapon.is_Oneshot = true
#	Weapon.position = Vector2()
#	Weapon.CurStats.AssignBaseStats(WeaponName)
	
#	get_node("WeaponHolster").add_child(Weapon)
#	Weapon.owner = self
#	AddWeaponToPool(WeaponName) # Checks if Weapon is alleged for the pool or if the pool is closed
	pass


# TODO Assign Stats
# TIP load the same projectile as the Weapons projectile var newInst = load(self.filename).instance()

# gets called under the Projectile, OnHitEffectEnemie
# HitObject, ObjectToSpawn, _Parent, _position, _InitDirection
func OnHit(HitObject, ObjectToSpawn, _Parent, _position, _InitDirection, _Instigator): # FIXME On hit effect
	ItemName = "OnHitCircleSpikes" # TODO THis is hard coded, don't do that
	SpawnNewWeapon(_position, _Instigator)
#	print(_position)
#	AddWeapon(_Parent, "OnHitSpikes", _position, _InitDirection)

	return
################################################ this is all gone I don't need this

	# FIXME  THIS SHIET NEEDS A REWRITE LIKE THE GENWEAPONS
	# DEPRICATED THIS SHIET NEED A REWRITE LIKE GENWEAPONS
	
	AssignBaseStats("OnHitSpikes")
	
	for i in range(0, ProjectileAmount):
		var newInst = ProjectileType.projectile.instance() # HACK that could be just a projectile scene
#		var newInst = load(ObjectToSpawn).instance()
		SpawnerDirecton.CirclePointsAmount = ProjectileAmount
#		_Parent.add_child(newInst)
		_Parent.get_tree().root.get_viewport().add_child(newInst)
		newInst.owner = _Parent.owner
		var InitSpawnerDirecton = SpawnerDirecton.GetSpawnDirections(i)
		#AudioSource : AudioStream, Volume = 0.0, pitch = 1.0, priority = -1, ComboName = ""
		SoundManager.PlaySound(SoundFile)
#		var ProjectilePosition = owner.position - (InitSpawnDirection * SpawnOffset) + Vector2(rand_range(-RandSpawnRadius, RandSpawnRadius), rand_range(-RandSpawnRadius, RandSpawnRadius)) # owner because weapons are on Vector2(0, 0)
		var ProjectilePosition = _position - (InitSpawnerDirecton * SpawnOffset) + Vector2(rand_range(-RandSpawnRadius, RandSpawnRadius), rand_range(-RandSpawnRadius, RandSpawnRadius)) 
		# func Shoot(_speed : float, _direction : Vector2, _texture, _damage, _CollisionRadius, _MaxRange, _KnockbackAmount, _ProjectilePosition, _OnHitEffectEnemie, _OnHitEffectWall)
		newInst.AssignData(ProjectileSpeed, InitSpawnerDirecton, SpriteResource, Damage, CollisionArea, MaxRange, KnockbackAmount, ProjectilePosition, OnHitEffectEnemie, OnHitEffectWall)

func AssignBaseStats(_WeaponName : String): # should that be in the stats container?
		if _WeaponName.empty():
			return

		var BaseStats : Dictionary = GameFunction.readCSV(DataPath.GetItemData())
		ProjectileAmount = int(BaseStats[_WeaponName]["ProjectileAmount"])
		ProjectileInterval = float(BaseStats[_WeaponName]["ProjectileInterval"])
		Damage = float(BaseStats[_WeaponName]["BaseDamage"])
		KnockbackAmount = float(BaseStats[_WeaponName]["Knockback"])
		CoolDown = float(BaseStats[_WeaponName]["Cooldown"])
		ProjectileSpeed = float(BaseStats[_WeaponName]["ProjectileSpeed"])
		MaxRange = float(BaseStats[_WeaponName]["MaxTravelRange"])
		SoundFile = AssignResource(BaseStats[_WeaponName]["SoundFile"])
		RandSpawnRadius = float(BaseStats[_WeaponName]["RandomSpawnRadius"])
		SpawnOffset = float(BaseStats[_WeaponName]["SpawnOffset"])
		
		# Assign Resources
		ProjectileType = AssignResource(BaseStats[_WeaponName]["Projectile"])
		SpawnerDirecton = AssignResource(BaseStats[_WeaponName]["SpawnType"])
		
		#Assign all Onhit Effects
		var EnemieHitEffects : Array
		EnemieHitEffects = BaseStats[_WeaponName]["OnHitEffectEnemie"].split(",", false)
		for HitEffect in EnemieHitEffects:
			OnHitEffectEnemie.append(AssignResource(HitEffect))
			pass
			
		var WallHitEffects : Array
		WallHitEffects = BaseStats[_WeaponName]["OnHitEffectWall"].split(",", false)
		for HitEffect in EnemieHitEffects:
			OnHitEffectWall.append(AssignResource(HitEffect))
			pass


		# you first have to cast to an int to convert a string to a bool
		var AnimationBool = int(BaseStats[_WeaponName]["AnimationBool"])
		if bool(AnimationBool) == true:
			# Procedurally create SpriteFrames Resource
			var SpriteAnimation = SpriteFrames.new()
			SpriteAnimation.add_animation("Idle")
			SpriteAnimation.set_animation_speed("Idle", 12)

			# get the directory, get all files and save it in a array
			var dir = Directory.new()
			var files = []
			dir.open(BaseStats[_WeaponName]["SpriteFiles"])
			dir.list_dir_begin(true)
			var file = dir.get_next()
			while file != '':
				if file.get_extension()in ["png", "jpg"]:
					files += [file] # Actually don't have to save this into an array
					var texture : Texture = AssignResource(dir.get_current_dir() + "/" + file)
					SpriteAnimation.add_frame("Idle", texture)
				file = dir.get_next()
			dir.list_dir_end()
			SpriteResource = SpriteAnimation
		else:
			SpriteResource = AssignResource(BaseStats[_WeaponName]["SpriteFiles"])
			pass

		# Assignt the collision Area
		var CollisionString : String = String(BaseStats[_WeaponName]["CollisionArea"])
		var SplittedString = CollisionString.split(",") # strip_edges() removes white space
		if SplittedString.size() <= 1:
			CollisionArea = float(SplittedString[0])
		else:
			CollisionArea = Vector2(float(SplittedString[0]), float(SplittedString[1]))
		pass

func AssignResource(ResourceString : String):
	if ResourceString == "none" or ResourceString.empty():
		return null
	
	return load(ResourceString)
	pass
