extends CanvasLayer

var SelectedCharacterData
var SelectedCharacterName = ""

var CharacterCard = preload("res://Nodes/Widget/CharacterCard.tscn")

var MainMenu = load("res://MainMenu.tscn")

func _ready():
	$"%ExitButton".connect("pressed", self, "_on_ExitButton_pressed")
	$"%StartButton".connect("pressed", self, "_on_StartButton_pressed")
	$"%StartButton".disabled = true
	
	InitCharacter()
	printerr("why")
#	SelectedCharacterData = GameFunction.readCSV(DataPath.PlayerData).values()
#	print(SelectedCharacterData.values())
	pass

# just important for queued GUIs
func AddToViewport():
	pass

# TODO Put the CSV DATA in here
func InitCharacter():
	
	printerr(OS.get_name())
	
#	if OS.get_name() == 'HTML5':
	for character in GameFunction.readJson('res://CSVData/CharacterBaseStats.json'):
		if str(character["CharacterName"]).empty():
			return

		var CharacterCardInst = CharacterCard.instance()
		CharacterCardInst.InitCard(str(character["CharacterName"]), str(character["IconResourcePath"]))

		# CharacterCardInst.InitCard(character["SpritePath"]) #add a sprite to your character
		CharacterCardInst.connect("SendCharacterName", self, 'ReceiveCharacterName')
		$"%CharacterCardHolder".add_child(CharacterCardInst)
#			pass
#	else:
#		for character in GameFunction.readCSV(DataPath.GetPlayerData()).values():
#			if str(character["CharacterName"]).empty():
#				return
#
#			var CharacterCardInst = CharacterCard.instance()
#			CharacterCardInst.InitCard(str(character["CharacterName"]), str(character["IconResourcePath"]))
#
#			# CharacterCardInst.InitCard(character["SpritePath"]) #add a sprite to your character
#			CharacterCardInst.connect("SendCharacterName", self, 'ReceiveCharacterName')
#			$"%CharacterCardHolder".add_child(CharacterCardInst)
#			pass
#		pass

func ReceiveCharacterName(CharacterName):
	print(CharacterName)
	SelectedCharacterName = CharacterName
	$"%StartButton".disabled = false
	pass


func _on_StartButton_pressed():
	PlayerManager.SelectedPlayerName = SelectedCharacterName
	var MapInstance = preload("res://Maps/MainMap.tscn").instance()
	get_tree().current_scene.get_node("CenterContainer/GamePlayViewport/Viewport").add_child(MapInstance)
	LevelManager.OnLevelStart()
	EnemySpawner.StartWaveSpawner()
	
	UiManager.RemoveUI(self)
	print("Load Level With character %s" %SelectedCharacterName)
	
	pass # Replace with function body.

func _on_ExitButton_pressed():

	var MainMenuInst = MainMenu.instance()
	UiManager.AddUI(MainMenuInst)
	UiManager.RemoveUI(self)
	pass # Replace with function body.
