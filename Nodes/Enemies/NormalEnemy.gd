extends KinematicBody2D

onready var NavAgent = get_node("NavigationAgent2D")
onready var AttackTick = $AttackTick

var target = Vector2(0, 0)
var velocity = Vector2(0, 0)
var AgentVel = Vector2(0, 0)
#var MovementSpeed = 30

var TakeDamageModArray = []

signal path_changed(path)
signal OnDeath(KilledActor)
signal OnTakeDamage(instigator, Damage)

var CurStats : EnemieStats = EnemieStats.new()
#var StatsScript = load("res://Data/EnemieStats.gd")

var KnockBackDir = Vector2(1, 1)
#var Weight = 1

var isAggro := true # FIXME just a dummy var doesn't do anything here

var isDead := false

onready var health = get_node("Stats/Health")

#var BaseStats : EnemyBaseStats = EnemyBaseStats.new()

#var crystal = preload("res://Nodes/Gems/PickUp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	NavAgent.set_target_location(target)
	AttackTick.connect("timeout", self, "OnAttackTickTimeOut")
	
#	var StatsResource = Resource.new()
#	StatsResource.script = StatsScript
#	CurStats = StatsResource
	
#	CurStats.AssignBaseStats("Skelleton", DataPath.EnemyData)
	health.connect("OnDeath", self, "OnDeath")
	health.connect("OnTakeDamage", self, "OnTakeDamage")
	# signal OnTakeDamage(instigator, Damage)
	
#	health.CurHealth = BaseStats.Health
	pass

func OnTakeDamage(_instigator, _Damage):
	if isDead == true:
		return

	if _instigator == PlayerManager.PlayerPawn: # FIXME poison effect do not have a instigator
		for mods in TakeDamageModArray:
			mods.OnTakeDamage(_instigator, _Damage)

	Triggered(true)
	emit_signal("OnTakeDamage")
	pass

func InitStats(_EnemyName):
	CurStats.AssignBaseStats(_EnemyName, 'res://CSVData/EnemyData.json')
	
	for WeaponName in CurStats.StartWeapons: # has to be done like that, otherwise if AddWeapon is Called and the PlayerPawn is not ready, the Weapon position is completelly
		AddWeapon(WeaponName)
		pass

	$AnimatedSprite.frames = CurStats.SpriteResource
	$AnimatedSprite.play("Idle")
#	MovementSpeed = CurStats.BaseMovementSpeed
	pass

func AddWeapon(WeaponName : String):
#	var CSVDATA = GameFunction.readCSV(DataPath.GetItemData())
	var CSVDATA
	
	for Weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		if Weapon.id == WeaponName:
			CSVDATA = Weapon
	
#	if OS.get_name() == 'HTML5':
#		for Weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
#			if Weapon.id == WeaponName:
#				CSVDATA = Weapon
#		pass
#	else:
#		CSVDATA = GameFunction.readCSV(DataPath.GetItemData())[WeaponName]
#		pass
	
	var Weapon = GameFunction.SpawnActor(load(CSVDATA["ItemPath"]), Vector2(), 0.0, Vector2(1, 1), get_node("WeaponHolster"), self)
	Weapon.Instigator = self
	Weapon.CurStats.AssignBaseStats(WeaponName, false)
#	var Weapon = load(CSVDATA[WeaponName]["ItemPath"]).instance()
#	add_child(Weapon)
#	get_node("WeaponHolster").add_child(Weapon)
	pass

func DeSpawn():
	print("despawn")
	queue_free()
	pass

func GetAllWeapons():
	var WeaponsArray : Array
	for child in $WeaponHolster.get_children():
		if child.CurStats != null:
			if child.CurStats.get("ItemName") != null: #check if Item has WeaponName property
				WeaponsArray.append(child)
	return WeaponsArray
	pass

func Triggered(_is_aggro):
	match _is_aggro:
		true:
			set_process(true)
			set_physics_process(true)
			AttackTick.start(0.1)
			for Weapon in GetAllWeapons():
				Weapon.Set_Active(true)
		false:
			set_process(false)
			set_physics_process(false)
			AttackTick.stop()
			for Weapon in GetAllWeapons():
				Weapon.Set_Active(false)
	pass

func OnDeath():
	if is_instance_valid(self) and isDead == false:
		
		for Drop in $"%Drops".get_children():
			Drop.RollDrop(self)
			pass

		$CollisionShape2D.disabled = true # disable collision so you can't attack the corps
		isDead = true #sets the target_velocity to
		$AnimatedSprite.animation = "Death"
#		self.queue_free()
#		AttackTick.stop()

		AttackTick.stop()
		
		emit_signal("OnDeath", self)
#		Triggered(false)
	pass

#_CastPosition : Vector2, CollisioArea, CollisionMask : PoolIntArray, MaxCollisions : int = 32, direct_space_state = null
func OnAttackTickTimeOut():
	var result = GameFunctionCast.MultiCircleCast(position, 12.0, [1], 1, get_world_2d().direct_space_state)
	for hit in result:
		if hit.collider.has_node("Stats/Health"):
			hit.collider.get_node("Stats/Health").TakeDamage(self, CurStats.AttackPoints)
			pass
		pass
#	for DamagedActor in CastAttack():
#		if is_instance_valid(DamagedActor.collider):
#			# has_node_and_resource
#			if DamagedActor.collider.has_node("Stats/Health"):
#				DamagedActor.collider.get_node("Stats/Health").TakeDamage(self, 10)
#		pass
	pass

func _physics_process(delta):
	# if target is not reached or is not dead Go to Target Direction, otherwise don't move (knockback still enabled)
	if !NavAgent.is_target_reached() and isDead == false: # and NavAgent.is_target_reachable()
		# get dir to target
		var move_direction = position.direction_to(NavAgent.get_next_location())
		AgentVel = move_direction * CurStats.BaseMovementSpeed
	else:
		AgentVel = Vector2()
	
	NavAgent.set_velocity(AgentVel + KnockBackDir)
	
	if OS.get_name() == "HTML5":
		velocity = move_and_slide(AgentVel + KnockBackDir * (delta*2))
	pass

func _process(delta):
	GlobalDraw.DrawCircle([position, 12, Color.red])

	if PlayerManager.PlayerPawn != null:
		target = PlayerManager.PlayerPawn.position
	NavAgent.set_target_location(target)
	pass

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	velocity = move_and_slide(safe_velocity)
	pass
	
func KnockBack(Instigator, KnockbackAmount):
#	Triggered(true)
	
	if KnockbackAmount == 0:
		return
	
	KnockBackDir = Instigator.position - self.position
	KnockBackDir = KnockBackDir.normalized() * KnockbackAmount / CurStats.Weight
#	MovementSpeed += KnockbackAmount
	$KnockBackTimer.start()
	pass
	
func OnKockBackTimerTimeout():
	KnockBackDir = Vector2(0, 0)
#	MovementSpeed = CurStats.BaseMovementSpeed
	pass

func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "Death":
		#printerr("enemy is dead is nice <---------------------")
#		set_process(false)
#		set_physics_process_internal(false)

		Triggered(false)
		
		$NavigationAgent2D.queue_free()
#		$NavigationAgent2D.avoidance_enabled = false
#		$NavigationAgent2D.radius = 0.0
#		$NavigationAgent2D.max_neighbors = 0
#		$NavigationAgent2D.neighbor_dist = 0

		yield(get_tree().create_timer(20.0), "timeout")
		
		queue_free()
		
		#FIXME cant update the nav map otherwise the game dies on me in realese export
#		$NavigationAgent2D.set_navigation_map($NavigationAgent2D.get_rid()) #updates the navigation map
		pass
	pass # Replace with function body.
