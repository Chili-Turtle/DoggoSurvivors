extends "res://Nodes/State/BaseState.gd"

func _ready():
	pass

func _process(delta):
	Stats.AddDamageMultiplier = PlayerManager.PlayerPawn.velocity.length() / PlayerManager.PlayerPawn.CurStats.GetMovementSpeed() *0.5
	pass

func OnTimeOut():
	pass

func OnIntervalTimeout():
	pass

func ActivateState():
	# Do StateStuff
	pass
