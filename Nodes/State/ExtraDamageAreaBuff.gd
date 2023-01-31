extends "res://Nodes/State/BaseState.gd"

var particleSystem = preload("res://ParticlesSytems/HealingParticles.tscn").instance()

func _ready():
#	CharacterResource.script = StatsScript
#	Stats.AddDamageMultiplier = 10 #half of the weapons damage
	add_child(particleSystem)
	pass

func OnTimeOut():
	print("State was removed")
#	queue_free()
	pass

func OnIntervalTimeout():
	pass

func ActivateState():
	# Do StateStuff
	pass
