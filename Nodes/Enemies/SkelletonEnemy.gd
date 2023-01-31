extends KinematicBody2D

onready var NavAgent = get_node("NavigationAgent2D")
onready var AttackTick = $AttackTick

var target = Vector2(0, 0)
var velocity = Vector2(0, 0)
var AgentVel = Vector2(0, 0)
var MovementSpeed = 30


signal path_changed(path)
signal OnDeath(KilledActor)

var CurStats : EnemieStats = EnemieStats.new()
var StatsScript = load("res://Data/EnemieStats.gd")

var KnockBackDir = Vector2(1, 1)
var Weight = 1

var isAggro = true # FIXME just a dummy var doesn't do anything here

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
	
	CurStats.AssignBaseStats("Skelleton", DataPath.GetEnemyData()) #Depricated 
	health.connect("OnDeath", self, "OnDeath")
	
#	health.CurHealth = BaseStats.Health
	MovementSpeed = CurStats.BaseMovementSpeed
	pass

func initStats(_EnemyName):
	CurStats.AssignBaseStats(_EnemyName, DataPath.GetEnemyData())
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
		
#		for i in range(0, (randi() % 3) + 1):
#			var expcrystal = crystal.instance()
#			expcrystal.position = position + Vector2(rand_range(-20, 20), rand_range(-20, 20))
#			get_parent().add_child(expcrystal)
			
		AttackTick.stop()
		$CollisionShape2D.disabled = true
		set_process(false)
		set_physics_process_internal(false)
		isDead = true
		$AnimatedSprite.animation = "Death"
#		self.queue_free()
		emit_signal("OnDeath", self)
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
	if !NavAgent.is_target_reached(): # and NavAgent.is_target_reachable()
		# get dir to target
		var move_direction = position.direction_to(NavAgent.get_next_location())
		AgentVel = move_direction * MovementSpeed
	else:
		AgentVel = Vector2()
	
	print(MovementSpeed)
	NavAgent.set_velocity(AgentVel + KnockBackDir)
	#print(NavAgent.is_target_reached())
	pass

func _process(delta):
	GlobalDraw.DrawCircle([position, 12, Color.red])

	if PlayerManager.PlayerPawn != null:
		target = PlayerManager.PlayerPawn.position
	NavAgent.set_target_location(target)
	pass

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if isDead == false:
		velocity = move_and_slide(safe_velocity)
	pass
	
func KnockBack(Instigator, KnockbackAmount):
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

func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	pass # Replace with function body.
