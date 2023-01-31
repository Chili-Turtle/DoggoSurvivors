extends Area2D

export var NodeToActivate : NodePath
export var FillTime = 3
export var SpillTime = 4

var Radius = 12
var CurRadius = 0
var Lucidity = 0.5
export var IsActive = true

func _ready():
	Radius = $"%CollisionShape2D".shape.radius
	pass

func _on_TriggerTimer_body_entered(body):
	if body == PlayerManager.PlayerPawn and IsActive == true:
#		if NodeToActivate != null:
		Lucidity = 1.0
		$Tween.remove_all()
		$Tween.interpolate_property(self, "CurRadius", CurRadius, Radius, FillTime, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		$Tween.start()
		pass

func _on_TriggerTimer_body_exited(body):
	if body == PlayerManager.PlayerPawn and IsActive == true:
		Lucidity = 0.3
		$Tween.remove_all()
		$Tween.interpolate_property(self, "CurRadius", CurRadius, 0, 8, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		$Tween.start()
	
	# Disable drawing
	if IsActive == false:
		Lucidity = 0.0
		update()
		pass
	pass

func _draw():
	draw_circle(Vector2(), CurRadius, Color(1.0, 1.0, 0.0, Lucidity/2))
	draw_arc(Vector2(), Radius + 0.75, 0, PI*2, 32, Color(1.0, 1.0, 0.0, Lucidity), 1.5, true)
	
func _on_Tween_tween_step(object, key, elapsed, value):
	update()
	pass

func _on_Tween_tween_completed(object, key):
	if CurRadius >= Radius:
		IsActive = false
		Lucidity = 0.0
		Trigger()
		pass
	pass

func Trigger():
	if get_node(NodeToActivate) != null:
		get_node(NodeToActivate).Trigger()
	pass
