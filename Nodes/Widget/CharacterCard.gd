extends Control

signal SendCharacterName(CharacterName)

func _ready():
	pass

func InitCard(CharacterName : String = "NoName", CharacterTexturePath : String = "res://icon.png"):
	$"%CharacterNameLabel".text = CharacterName
	$"%CharacterTexture".texture = LoadImageResource(CharacterTexturePath)
	pass

func LoadImageResource(CharacterTexturePath):
	# check if this is a scene or a normal Image
	var imagetexture = ImageTexture.new()
	if CharacterTexturePath.ends_with("tres"):
		imagetexture = load(CharacterTexturePath)
	else:
		imagetexture.load(CharacterTexturePath)
		pass
		
	return imagetexture
	pass

func _on_CharacterCard_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			print(event)
			emit_signal("SendCharacterName", $"%CharacterNameLabel".text)
		pass
	pass # Replace with function body.


func _on_CharacterCard_mouse_entered():
	pass # Replace with function body.
