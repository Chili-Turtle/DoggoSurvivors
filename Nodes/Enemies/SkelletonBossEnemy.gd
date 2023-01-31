extends KinematicBody2D

onready var NavAgent = get_node("NavigationAgent2D")
onready var AttackTick = $AttackTick

var target = Vector2(0, 0)
var velocity = Vector2(0, 0)
var AgentVel = Vector2(0, 0)

var TakeDamageModArray = []

var MovementSpeed = 50

var CurStats : Resource
var StatsScript = load("res://Data/EnemieStats.gd")

var KnockBackDir = Vector2(1, 1)
var Weight = 2.0

signal OnDeath(KilledActor)
signal OnTakeDamage(instigator, Damage)

var isDead := false
var isAggro := false

onready var health = get_node("Stats/Health")

var OrigionPoint : Vector2 setget SetOrigionPoint

func SetOrigionPoint(value):
	OrigionPoint = value
	pass

func InitStats(_Name):
	pass

func Triggered(_active):
	isAggro = _active
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = $VisibilityNotifier2D.is_on_screen()
	
	NavAgent.set_target_location(target)
	AttackTick.connect("timeout", self, "OnAttackTickTimeOut")
	
	var StatsResource = Resource.new()
	StatsResource.script = StatsScript
	CurStats = StatsResource
	
	CurStats.AssignBaseStats("SkelletonBoss", 'res://CSVData/EnemyData.json')
#	AssignBaseStats("SkelletonBoss") # TODO This should be called when spawned
	
	health.connect("OnDeath", self, "OnDeath")
	health.connect("OnTakeDamage", self, "OnTakeDamage")
	
	health.isInvurnable = false
	
	MovementSpeed = CurStats.BaseMovementSpeed
	
	SetOrigionPoint(position)
	pass

func Activate():
	health.isInvurnable = true
	isAggro = true
	pass

func OnTakeDamage(_instigator, _Damage):
	if _instigator == PlayerManager.PlayerPawn:
		isAggro = true
		for mods in TakeDamageModArray:
			mods.OnTakeDamage(_instigator, _Damage)
	
	
	emit_signal("OnTakeDamage")
	pass

func DeSpawn():
	print("despawn")
	queue_free()
	pass

func OnDeath():
	
	self.emit_signal("OnDeath", self)
	if is_instance_valid(self) and isDead == false:
		for Drop in $"%Drops".get_children():
			Drop.RollDrop(self)
			pass

		AttackTick.stop()
		$CollisionShape2D.disabled = true
		set_process(false)
		set_physics_process_internal(false)
		isDead = true
		$AnimatedSprite.animation = "Death"
#		self.queue_free()
		emit_signal("OnDeath", self)
	pass

func OnAttackTickTimeOut():
	var result = GameFunctionCast.MultiCircleCast(position, 20.0, [1], 1, get_world_2d().direct_space_state)
	for hit in result:
		if hit.collider.has_node("Stats/Health"):
			hit.collider.get_node("Stats/Health").TakeDamage(self, 10)
			pass
		pass

		pass
	pass

#func DamageCast():
#	var result = GameFunctionCast.MultiCircleCast(position, 20.0, [1], 1, get_world_2d().direct_space_state)
#	for hit in result:
#		if hit.collider.has_node("Stats/Health"):
#			hit.collider.get_node("Stats/Health").TakeDamage(self, 10)
#			pass
#	pass

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
	#print(NavAgent.is_target_reached())
	
	if OS.get_name() == "HTML5":
		velocity = move_and_slide(AgentVel + KnockBackDir * (delta*2))
	pass

func _process(delta):
	if isAggro == false:
		return

	GlobalDraw.DrawCircle([position, 20, Color.red])
	if PlayerManager.PlayerPawn != null:
		target = PlayerManager.PlayerPawn.position
	NavAgent.set_target_location(target)
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
	
	KnockBackDir = KnockBackDir.normalized() * (KnockbackAmount / Weight)
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

func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	pass # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	pass # Replace with function body.
