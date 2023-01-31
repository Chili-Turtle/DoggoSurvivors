extends CanvasLayer

var MainMenu = preload("res://MainMenu.tscn")

func AddToViewport():
	get_tree().paused = true
	pass

func _ready():
	$"%Exit".connect("pressed", self, "OnExitButtonPressed")
	$"%Continue".connect("pressed", self, "OnContinueButtonPressed")
	
	pass

func OnExitButtonPressed():
	get_tree().quit()
#	var MainMenuInt = MainMenu.instance()
#
#	var MapContainer = get_tree().current_scene.get_node("CenterContainer/GamePlayViewport/Viewport")
#	for child in MapContainer.get_children():
#		MapContainer.remove_child(child)
#
#	UiManager.AddUI(MainMenuInt)
#	get_tree().paused = false
#	UiManager.RemoveUI(self)
	pass
	
func OnContinueButtonPressed():
	get_tree().paused = false
	UiManager.RemoveUI(self)
	pass
