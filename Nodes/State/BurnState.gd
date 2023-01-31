extends "res://Nodes/State/BaseState.gd"

# timer state

#onready var StateTimer = $"%StateTimer"
#onready var StateIntervalTimer = $"%StateIntervalTimer"

#var StateName = "BurningState"

#var StateTime = 2.0
#var StateInterval = 0.5

#var StateCounter = 0

var Damage = 1

var particleSystem = preload("res://ParticlesSytems/PoisionEffect.tscn").instance()

func ResetTime():
	StateTimer.start(StateTime)
	pass

func _ready():
#	StateTimer.connect("timeout", self, "OnTimeOut")
#	StateIntervalTimer.connect("timeout", self, "OnIntervalTimeout")
#	StateTimer.start(StateTime)
#	StateIntervalTimer.start(StateInterval)
	add_child(particleSystem)
#	InstancedParticles.owner = owner
#	InstancedParticles.position = PlayerManager.PlayerPawn.position
	
	pass

# Play Particles
# If already state exist reset timer
# Should I just have a timer for State parent, and go threw all States?

func OnTimeOut():
	particleSystem.queue_free() # does not work when enemie died before
	queue_free()
	pass

func OnIntervalTimeout():
	if owner.has_node("Stats/Health"):
		owner.get_node("Stats/Health").TakeDamage(self, Damage)

	# Do StateStuff
#	StateCounter += 1
#	if StateCounter > 10:
#		queue_free()
#		pass
	pass

func ActivateState():
	pass
