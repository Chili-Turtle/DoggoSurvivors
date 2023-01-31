class_name AirTimeEndSpawnBombArea
extends AirTimeEnd

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

func AirTimeEnd(_Instigator, _positoin):
#	var CSVDATA = GameFunction.readCSV(DataPath.GetItemData())
	var CSVDATA 
	for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		pass
		
	
	var Weapon = GameFunction.SpawnActor(load("res://Nodes/Weapons/GeneratedWeapons/ProjectileSpawner.tscn"), _positoin, 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer) # FIXME This is plane Weird should a onhit effect be a weapon/projectile
	Weapon.Instigator = _Instigator
	Weapon.CurStats.AssignBaseStats("BombaArea", false)
	
	# Hacked I level up the Weapon before I shoot
	for i in range(0, LevelIndex):
		Weapon.LevelUp()
		pass
	pass
