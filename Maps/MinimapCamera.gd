extends Node2D

func _ready():
	pass

func _process(delta):
	if PlayerManager.PlayerPawn != null:
		position = PlayerManager.PlayerPawn.position
		pass
	pass
