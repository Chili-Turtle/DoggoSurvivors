extends Node2D

var PlayerCamera : Camera2D

signal CameraAdded()
signal CameraRemoved()

func _ready():
	pass
	
func get_camera():
	if is_instance_valid(PlayerCamera) and PlayerCamera != null:
		return PlayerCamera
	else:
		return null
	pass

func set_camera(_PlayerCamera : Camera2D):
	PlayerCamera = _PlayerCamera
	emit_signal("CameraAdded")
	pass

#func _draw():
#	draw_circle(PlayerCamera.get_camera_screen_center() , 10, Color(0,1,1,1))
#	draw_circle(PlayerCamera.get_viewport_rect().size/2 * PlayerCamera.zoom , 10, Color(0,1,1,1))
#	var draw_pos = (PlayerCamera.get_camera_screen_center()) - (PlayerCamera.get_viewport_rect().size/2 * PlayerCamera.zoom) # local remove the position
#	draw_circle(draw_pos , 10, Color(1,1,0,1))
#
#	var RectMidPoint = PlayerCamera.get_camera_screen_center() - PlayerCamera.get_viewport_rect().size/2 * PlayerCamera.zoom
#	draw_rect(Rect2(RectMidPoint ,PlayerCamera.get_viewport_rect().size * PlayerCamera.zoom), Color(1, 1, 0, 1), false, 10.0, false)
#	pass
#
#func _process(delta):
#	update()
