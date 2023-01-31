extends Node

var MainMenu = preload("res://MainMenu.tscn")

func _ready():
	#$CanvasLayer/Control/TextureRect/ViewportContainer/Viewport.world_2d = $ViewportContainer/Viewport/MainMap.get_world_2d()

	var MainMenuInst = MainMenu.instance()
	UiManager.AddUI(MainMenuInst)
	pass
