extends Area2D

export var NodeToActivate : NodePath

export var IsActive = true

func _on_Trigger_body_entered(body):
	if body == PlayerManager.PlayerPawn:
		if NodeToActivate != null:
			pass
		pass # Replace with function body.
