extends Resource

class_name WeaponStats

export var ProjectileType : Resource
export var SpawnerDirecton : Resource
export(Array, Resource) var OnHitEffectEnemie #Resource
export(Array, Resource) var OnHitEffectWall  #Resource Godot4 Array[int]
export(Array, Resource) var OnAirTimeEndArray
export(Array, Resource) var OnWeaponAnimationFinished

# None resource Stats
var ItemName = ""
var CurLevel = 1
var MaxLevel = 9 #TODO Find a otherway to Init max level of a weapon

var Damage = 100
var CollisionArea
var ProjectileSpeed
var ProjectileAmount
var CoolDown
var ProjectileInterval
var KnockbackAmount
var MaxRange
var MaxAirTime
var CriticalChance
var CriticalMultiplier
var RandSpawnRadius
var SpawnOffset
var AnimationBool
var SpriteResource
var SoundFile
var SpawnType
var ItemType
var ItemDescription
var ItemPath
var ScaleMultiplier : float
var HasInitRotation : bool
var SpriteRotation
var OneShot
var CollisionMask : Array
var ProjectileMovement
var BurstAmount : int
var BurstCooldown : float
var ShootDelay : float
var AutoStartProjectile : bool
var AttachedAtStart : bool
var IndependentSprite : bool
var KnockBackCenterProjectile : bool
var AnimationLoopingBool : bool
var AnimaitonLength : float


# Growht Data
var WeaponBaseDamgeGrowth : Array
var CollisionAreaGrowth : Array
var ProjectileSpeedGrowth : Array
var ProjectileAmountGrowth : Array
var CooldownGrowth : Array
var ProjectileIntervalGrowth : Array
var KnockbackGrowth : Array
var MaxTravelRangeGrowth : Array
var MaxAirTimeGrowth : Array
var CriticalChanceGrowth : Array
var CriticalMultiplierGrowth : Array
var RandomSpawnRadiusGrowth : Array
var SpawnOffsetGrowth: Array
var BurstAmountGrowth : Array
var BurstOffset : Array

func AssignBaseStats(_ItemName : String, _AddToPool : bool = true): # should that be in the stats container?
	if _ItemName.empty():
		return
		
	var BaseStats : Dictionary

#	if OS.get_name() == 'HTML5':
#		for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
#			if weapon.id == _ItemName:
#				BaseStats = weapon
#	else:
#		BaseStats = GameFunction.readCSV(DataPath.GetItemData())[_ItemName]
#		pass
	
	for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		if weapon.id == _ItemName:
			BaseStats = weapon
		
	ProjectileAmount = int(BaseStats["ProjectileAmount"])
	ProjectileInterval = float(BaseStats["ProjectileInterval"])
	ItemName = BaseStats["WeaponName"]
	Damage = float(BaseStats["BaseDamage"])
	KnockbackAmount = float(BaseStats["Knockback"])
	CoolDown = float(BaseStats["Cooldown"])
	ProjectileSpeed = float(BaseStats["ProjectileSpeed"])
	MaxRange = float(BaseStats["MaxTravelRange"])
	MaxAirTime = float(BaseStats["MaxAirTime"])
	RandSpawnRadius = float(BaseStats["RandomSpawnRadius"])
	SpawnOffset = float(BaseStats["SpawnOffset"])
	ItemDescription = str(BaseStats["ItemDescription"])
	ItemType = str(BaseStats["ItemType"])
	ScaleMultiplier = float(BaseStats["ScaleMultiplier"])
	HasInitRotation = bool(int(BaseStats["HasInitRotation"]))
	SpriteRotation = float(BaseStats["SpriteRotation"])
	OneShot = bool(int(BaseStats["OneShot"]))
	BurstAmount = int(BaseStats["BurstAmount"])
	BurstCooldown = float(BaseStats["BurstCooldown"])
	ShootDelay = float(BaseStats["ShootDelay"])
	AutoStartProjectile = bool(int(BaseStats["AutoStartProjectile"]))
	AttachedAtStart = bool(int(BaseStats["AttachedAtStart"]))
	IndependentSprite = bool(int(BaseStats["IndependentSprite"]))
	KnockBackCenterProjectile = bool(int(BaseStats["KnockBackCenterProjectile"]))
	AnimationLoopingBool = bool(int(BaseStats["AnimationLoopingBool"]))
	AnimaitonLength = float(BaseStats["AnimaitonLength"])

	InitGrowthData(BaseStats, _ItemName)
		
		# Assign Resources
	# DEPRICATED Why Did I do this -> ProjectileType Resource just with a hard coded variable project with a NodePath?
	# ProjectileType = GameFunction.AssignResource(BaseStats[_ItemName]["ProjectileType"])
	ProjectileType = GameFunction.AssignResource(BaseStats["Projectile"])
	SpawnerDirecton = GameFunction.AssignResource(BaseStats["SpawnType"])
	SoundFile = GameFunction.AssignResource(BaseStats["SoundFile"])
	ProjectileMovement = GameFunction.AssignResource(BaseStats["ProjectileMovement"])
		
		#Assign all Onhit Effects
	var EnemieHitEffects : Array
	EnemieHitEffects = BaseStats["OnHitEffectEnemie"].split(",", false)
	for HitEffect in EnemieHitEffects:
		OnHitEffectEnemie.append(GameFunction.AssignResource(HitEffect.strip_edges()))
		print(OnHitEffectEnemie)
		pass
			
	var WallHitEffects : Array
	WallHitEffects = BaseStats["OnHitEffectWall"].split(",", false)
	for HitEffect in EnemieHitEffects:
		OnHitEffectWall.append(GameFunction.AssignResource(HitEffect))
		pass
	
	var AirTimeEndArray : Array
	AirTimeEndArray = BaseStats["OnAirTimeEnd"].split(",", false)
	for AirTimeEndEffect in AirTimeEndArray:
		OnAirTimeEndArray.append(GameFunction.AssignResource(AirTimeEndEffect))
		pass
	
	var WeaponAnimationFinishedArray : Array
	WeaponAnimationFinishedArray = BaseStats["OnWeaponAnimationFinished"].split(",", false)
	for WeaponAnimationFinishedEffects in WeaponAnimationFinishedArray:
		OnWeaponAnimationFinished.append(GameFunction.AssignResource(WeaponAnimationFinishedEffects))
		pass

	######## Create sprite files #############
	# you first have to cast to an int to convert a string to a bool
	var AnimationBool = int(BaseStats["AnimationBool"])
#	if bool(AnimationBool) == true:
	# DEPRICATED NOW ALL SPRITES ARE ANIMATION SPRITES
		# Procedurally create SpriteFrames Resource
	var SpriteAnimation = SpriteFrames.new()
#	SpriteAnimation.add_animation("default")
	SpriteAnimation.set_animation_speed("default", 12)
	SpriteAnimation.set_animation_loop("default", AnimationLoopingBool)

	# get the directory, get all files and save it in a array
	if bool(AnimationBool) == true:
		var dir = Directory.new()
		var files = []
		var SpriteCount = 0
		dir.open(BaseStats["SpriteFiles"])
		dir.list_dir_begin(true)
		var file = dir.get_next()
		while file != '':
			if file.get_extension()in ["png", "jpg", 'PNG', 'jpg', 'tres']: #FIXME can't use folder with PNGs, wild guess can't use compressed png files
#				files += [file] # Actually don't have to save this into an array
				var texture : Texture = load(dir.get_current_dir() + "/" + file)
				SpriteAnimation.add_frame("default", texture)
				SpriteCount += 1
			file = dir.get_next()
		dir.list_dir_end()
		SpriteAnimation.set_animation_speed("default", SpriteCount / AnimaitonLength)
		SpriteResource = SpriteAnimation
	else:
		SpriteAnimation.add_frame("default", load(BaseStats["SpriteFiles"]))
		SpriteResource = SpriteAnimation
#		SpriteResource = load(BaseStats[_ItemName]["SpriteFiles"])
		pass
	
		#ColliisonMask
	for StringElements in str(BaseStats["CollisionMask"]).split(",", false):
		CollisionMask.append(int(StringElements))

		# Assignt the collision Area
	var CollisionString : String = String(BaseStats["CollisionArea"])
	var SplittedString = CollisionString.split(",") # strip_edges() removes white space
	if SplittedString.size() <= 1:
		CollisionArea = float(SplittedString[0])
	else:
		CollisionArea = Vector2(float(SplittedString[0]), float(SplittedString[1]))
	
	if _AddToPool == true:
		CheckWeaponPoolAssignment()
	pass

func InitGrowthData(_BaseStats, _ItemName):
		for StringElements in str(_BaseStats["WeaponBaseDamgeGrowth"]).split(",", false):
			WeaponBaseDamgeGrowth.append(float(StringElements))
		
		for StringElements in str(_BaseStats["CollisionAreaGrowth"]).split(",", false):
			CollisionAreaGrowth.append(float(StringElements))
		
		for StringElements in str(_BaseStats["ProjectileSpeedGrowth"]).split(",", false):
			ProjectileSpeedGrowth.append(float(StringElements))
			
		for StringElements in str(_BaseStats["ProjectileAmountGrowth"]).split(",", false):
			ProjectileAmountGrowth.append(float(StringElements))
			
		for StringElements in str(_BaseStats["CooldownGrowth"]).split(",", false):
			CooldownGrowth.append(float(StringElements))
			
		for StringElements in str(_BaseStats["ProjectileIntervalGrowth"]).split(",", false):
			ProjectileIntervalGrowth.append(float(StringElements))
			
		for StringElements in str(_BaseStats["KnockbackGrowth"]).split(",", false):
			KnockbackGrowth.append(float(StringElements))
			
		for StringElements in str(_BaseStats["MaxTravelRangeGrowth"]).split(",", false):
			MaxTravelRangeGrowth.append(float(StringElements))
			
		for StringElements in str(_BaseStats["MaxAirTimeGrowth"]).split(",", false):
			MaxAirTimeGrowth.append(float(StringElements))
			
#		Damage += CriticalChanceGrowth # TODO Implemet crit
#		Damage += CriticalMultiplierGrowth
		for StringElements in str(_BaseStats["RandomSpawnRadiusGrowth"]).split(",", false):
			RandomSpawnRadiusGrowth.append(float(StringElements))
			
		for StringElements in str(_BaseStats["SpawnOffsetGrowth"]).split(",", false):
			SpawnOffsetGrowth.append(float(StringElements))
		
		for StringElements in str(_BaseStats["BurstAmountGrowth"]).split(",", false):
			BurstAmountGrowth.append(int(StringElements))
		
		for StringElements in str(_BaseStats["BurstOffset"]).split(",", false):
			BurstOffset.append(float(StringElements))

		print(WeaponBaseDamgeGrowth)

func UpgradeWeapon():
	if CurLevel <= MaxLevel:
		Damage += GetArrayValue(WeaponBaseDamgeGrowth, CurLevel-1)
		print(typeof(Damage))
		if typeof(CollisionArea) == TYPE_VECTOR2:
			CollisionArea += Vector2(1, 1) * GetArrayValue(CollisionAreaGrowth, CurLevel-1)
		else:
			CollisionArea += GetArrayValue(CollisionAreaGrowth, CurLevel-1)
		ProjectileSpeed += GetArrayValue(ProjectileSpeedGrowth, CurLevel-1)

		ProjectileAmount +=GetArrayValue(ProjectileAmountGrowth, CurLevel-1)
		CoolDown += GetArrayValue(CooldownGrowth, CurLevel-1)
		ProjectileInterval += GetArrayValue(ProjectileIntervalGrowth, CurLevel-1)
		KnockbackAmount += GetArrayValue(KnockbackGrowth, CurLevel-1)
		MaxRange += GetArrayValue(MaxTravelRangeGrowth, CurLevel-1)
		MaxAirTime += GetArrayValue(MaxAirTimeGrowth, CurLevel-1) 
#		Damage += CriticalChanceGrowth # TODO Implemet crit
#		Damage += CriticalMultiplierGrowth
		RandSpawnRadius += GetArrayValue(RandomSpawnRadiusGrowth, CurLevel-1)
		SpawnOffset += GetArrayValue(SpawnOffsetGrowth, CurLevel-1)
		
		BurstAmount += GetArrayValue(BurstAmountGrowth, CurLevel-1)
		
		CurLevel +=1

		CheckWeaponPoolAssignment()
		pass
	pass
	

func CheckWeaponPoolAssignment(): # is the pool closed?
	if ItemType != "Weapon": # safty I I forget to disable assign to weapon pool
		return
	
	if CurLevel < MaxLevel:
		LevelManager.AddToItemPool(ItemName)
	else:
		LevelManager.RemoveFromItemPool(ItemName)
		print("Remove Item form pool")
	pass

func GetArrayValue(ArrayItem, Index):
	if ArrayItem.size() == 0 or Index >= ArrayItem.size():
		return 0
	return ArrayItem[Index]
	pass

# ------------ Calculate Stats ----------------
func GetDamage() -> float:
	return Damage * PlayerManager.PlayerPawn.CurStats.GetDamageMultiplier()
	pass

func GetProjectileSpeed() -> float:
	return ProjectileSpeed + PlayerManager.PlayerPawn.CurStats.GetProjectileSpeed() # TODO ADD PLAYER PROJECTILE SPEED * PlayerManager.PlayerPawn.CurStats.GetProjectileAmount()
	pass

func GetProjectileAmount() -> int:
	return ProjectileAmount + PlayerManager.PlayerPawn.CurStats.GetProjectileAmount()
	pass

func GetMaxRange() -> float: # TODO ADD MAX RANGE FROM PLAYER
	return MaxRange
	pass

func GetKnockBackAmount() -> float: # TODO ADD PLAYERKNOCKBACK
	return KnockbackAmount + PlayerManager.PlayerPawn.CurStats.GetKnockbackAmount()
	pass

func GetCollisionArea():
	return  CollisionArea * PlayerManager.PlayerPawn.CurStats.GetAreaMultiplier()
	pass

func GetCooldown() -> float:
	return CoolDown * PlayerManager.PlayerPawn.CurStats.GetCooldownMultiplier()
	pass

