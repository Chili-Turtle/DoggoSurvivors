extends CanvasLayer

func _ready():
	$AnimationPlayer.play("NotificationIn")
	
func AddToViewport():
	pass

func SetNotificationText(_text):
	$Panel/MarginContainer/Label.text = _text
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "NotificationIn":
		UiManager.RemoveUI(self)
		pass
	pass # Replace with function body.
