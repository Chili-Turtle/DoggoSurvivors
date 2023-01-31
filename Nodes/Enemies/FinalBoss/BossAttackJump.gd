extends BossAttack
class_name BossAttackJump

var Instigator
var RandomPos : Vector2

func StartAttack(_position, _Instigator):
	randomize()

	var RandomDistance = rand_range(60, 100)
	var RandomDirection = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	var RandomPoint = RandomDirection * RandomDistance
	RandomPos = _Instigator.OrigionPoint + RandomPoint
	
	_Instigator.NavAgent.connect("target_reached", self, "OnTargetReached")
	_Instigator.get_node("AnimatedSprite").connect("animation_finished", self , "OnAnimationFinished")
	_Instigator.get_node("Shadow").self_modulate = Color(0,0,0,0.3)
	_Instigator.get_node("AnimatedSprite").play("JumpStarted")
	


	Instigator = _Instigator
	pass

func OnTargetReached():
	# bugfix for the first jump (otherwise jump on place)
	if Instigator.position.distance_to(RandomPos) > 10:
		Instigator.target = RandomPos
		return
	
	if Instigator.get_node("AnimatedSprite").animation != "JumpFinished":
		Instigator.get_node("AnimatedSprite").play("JumpFinished")
		pass
	pass

func OnAttackFinished():
	emit_signal("AttackFinished") #connect to the enemie
	Instigator.NavAgent.disconnect("target_reached", self, "OnTargetReached")
	Instigator.get_node("AnimatedSprite").disconnect("animation_finished", self , "OnAnimationFinished")
	pass

func OnAnimationFinished():
	if Instigator.get_node("AnimatedSprite").get_animation() == "JumpStarted":
		Instigator.target = RandomPos
		Instigator.MovementSpeed = 100
		Instigator.Collision.disabled = true
		pass
	elif Instigator.get_node("AnimatedSprite").get_animation() == "JumpFinished":
		Instigator.MovementSpeed = Instigator.CurStats.BaseMovementSpeed
		Instigator.Collision.disabled = false
		Instigator.target = PlayerManager.PlayerPawn
		Instigator.get_node("Shadow").self_modulate = Color(0,0,0,0)
		OnGroundAttack()
		pass

func OnGroundAttack():
#	var CSVDATA = GameFunction.readCSV(DataPath.GetItemData())
	var CSVDATA
	for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		pass
		
	var Weapon = GameFunction.SpawnActor(load("res://Nodes/Weapons/GeneratedWeapons/ProjectileSpawner.tscn"), Instigator.position, 0, Vector2(1, 1), LevelManager.SpawnContainer, LevelManager.SpawnContainer)
	Weapon.Instigator = Instigator
	Weapon.CurStats.AssignBaseStats("GroundPound", false)
	for i in range(1, Instigator.Level):
		Weapon.CurStats.UpgradeWeapon()
		printerr("jump is upgraded")
	Weapon.connect("AttackFinished", self, "OnAttackFinished")
