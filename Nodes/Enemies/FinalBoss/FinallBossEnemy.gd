extends KinematicBody2D

onready var NavAgent = get_node("NavigationAgent2D")
onready var AttackTick = $AttackTick
onready var Collision = $CollisionShape2D

var target = Vector2(0, 0)
var velocity = Vector2(0, 0)
var AgentVel = Vector2(0, 0)

var Phase = 1
var Level = 1

var MovementSpeed = 30

var CurStats : Resource
var StatsScript = load("res://Data/EnemieStats.gd")

var KnockBackDir = Vector2(1, 1)
var Weight = 2.0

export var BossAttacks : Array = [preload("res://Nodes/Enemies/FinalBoss/BossAttack8WayBulletHell.tres"), preload("res://Nodes/Enemies/FinalBoss/BossAttackWindScar.tres"), preload("res://Nodes/Enemies/FinalBoss/BossAttackJump.tres")] # preload("res://Nodes/Enemies/FinalBoss/BossAttackJump.tres"), preload("res://Nodes/Enemies/FinalBoss/BossAttackWindScar.tres")

var BossHealthBar = preload("res://Nodes/Widget/BossHeahlthBar.tscn")
var BossHealthBarInstance = null

signal path_changed(path)
signal OnDeath(KilledActor)

var isDead := false
var isAggro := false

var OrigionPoint : Vector2 setget SetOrigionPoint

onready var health = get_node("Stats/Health")

func OnAttackFinished(Attack):
	Attack.disconnect("AttackFinished", self, "OnAttackFinished")
	printerr("attack finished")

	AttackTick.start()
	pass

func SetOrigionPoint(value):
	OrigionPoint = value
	pass

func Trigger():
	if isDead == true:
		return

	SetActivationState(true)
	UiManager.AddUI(BossHealthBarInstance)
	
	if PlayerManager.PlayerPawn != null: #FIXME this should be on map start or something, (OnReady ->the player is not set yet)
		target = PlayerManager.PlayerPawn
	pass

func SetActivationState(_state : bool):
	match _state:
		true:
			isAggro = true
			AttackTick.start()
			Collision.disabled = false
			set_process(true)
			set_physics_process_internal(true)
		false:
			isAggro = false
			AttackTick.stop()
			Collision.disabled = true
			set_process(false)
			set_physics_process_internal(false)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	NavAgent.set_target_location(target)
	
	AttackTick.connect("timeout", self, "OnAttackTickTimeOut")
	
	var StatsResource = Resource.new()
	StatsResource.script = StatsScript
	CurStats = StatsResource
	
	CurStats.AssignBaseStats("FinalBoss", 'res://CSVData/EnemyData.json')
#	AssignBaseStats("SkelletonBoss") # TODO This should be called when spawned
	
	health.connect("OnDeath", self, "OnDeath")
	health.connect("OnTakeDamage", self, "OnTakeDamage")
	
	MovementSpeed = CurStats.BaseMovementSpeed
	SetActivationState(false)
	
	BossHealthBarInstance = BossHealthBar.instance()
	BossHealthBarInstance.UpdateHealth(CurStats.CurHealth * 100 / CurStats.AMaxHealth)
	BossHealthBarInstance.SetName("Super Long Boss Name van der hosen")
	
#	Trigger() # DEBUG triggers the enemy
	SetOrigionPoint(position)
	target = OrigionPoint
	
	pass

func OnTakeDamage(instigator, Damage):
	match Phase:
		1:
			if CurStats.CurHealth <= CurStats.AMaxHealth*0.6:
				printerr("BossEnemy level up")
				Level += 1
				Phase = 2
		2:
			if CurStats.CurHealth <= CurStats.AMaxHealth*0.30:
				printerr("BossEnemy level up")
				Level += 1
				Phase = 3
			pass
		3:
			pass
	
	if is_instance_valid(BossHealthBarInstance):
		BossHealthBarInstance.UpdateHealth(CurStats.CurHealth * 100 / CurStats.AMaxHealth)
		pass
	
	if instigator == PlayerManager.PlayerPawn:
#		isAggro = true
		pass
	pass

func DeSpawn():
	print("despawn")
	queue_free()
	pass

func OnDeath():
	if is_instance_valid(self) and isDead == false:
		
		for Drop in $"%Drops".get_children():
			Drop.RollDrop(self)
			pass
		
		SetActivationState(false)
		isDead = true
		$AnimatedSprite.animation = "Death"
#		self.queue_free()
		emit_signal("OnDeath", self)
		UiManager.RemoveUI(BossHealthBarInstance)
	pass

func OnAttackTickTimeOut():
	if BossAttacks.size() > 0:
		var RandAttack = BossAttacks[randi() % BossAttacks.size()]
		RandAttack.StartAttack(Vector2(1000, 1000), self) # DEBUG start attack
		RandAttack.connect("AttackFinished", self, "OnAttackFinished", [RandAttack])
	pass

func _physics_process(delta):
	if isAggro == false:
		return
	
	if !NavAgent.is_target_reached(): # and NavAgent.is_target_reachable()
		# get dir to target
		var move_direction = position.direction_to(NavAgent.get_next_location())
		AgentVel = move_direction * MovementSpeed
	else:
		AgentVel = Vector2()
	
	NavAgent.set_velocity(AgentVel + KnockBackDir)
	
	if OS.get_name() == "HTML5":
		velocity = move_and_slide(AgentVel + KnockBackDir * (delta*2))
	#print(NavAgent.is_target_reached())
	pass

func _process(delta):
	if isAggro == false:
		return

	GlobalDraw.DrawCircle([position, 20, Color.red])
	
	if typeof(target) != TYPE_VECTOR2:
		NavAgent.set_target_location(target.position)
	else:
		NavAgent.set_target_location(target)
		pass
	pass

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if isDead == false:
		velocity = move_and_slide(safe_velocity)
	pass

func KnockBack(Instigator, KnockbackAmount : float):
	print(KnockbackAmount)
	if KnockbackAmount == 0:
		return

	KnockBackDir = Instigator.position - self.position
	
	KnockBackDir = KnockBackDir.normalized() * KnockbackAmount / Weight
#	MovementSpeed += KnockbackAmount
	$KnockBackTimer.start()
	pass
	
func OnKockBackTimerTimeout():
	KnockBackDir = Vector2(0, 0)
#	MovementSpeed = CurStats.BaseMovementSpeed
	pass

func OnAnimationFinished():
	if $AnimatedSprite.get_animation() == "Death":
		self.queue_free()
	pass # Replace with function body.
