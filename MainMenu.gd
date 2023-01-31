extends CanvasLayer

var PlayerSelectScreen = preload("res://Nodes/Widget/CharacterSelectScreen.tscn")

func _ready():
	
	pass
	
func AddToViewport():
	pass

func _on_Button_pressed():
	var PlayerSelectScreenInst = PlayerSelectScreen.instance()
	UiManager.AddUI(PlayerSelectScreenInst)
	UiManager.RemoveUI(self)
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.
