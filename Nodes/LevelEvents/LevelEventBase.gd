extends Resource

class_name BaseLevelEvent

func _ready():
	pass

func StartEvent():
	printerr("I am doing my cool event")
	pass

func EndEvent():
	print("Event has ended")
	pass

func OnPlayerEntered(_Section):
	pass
