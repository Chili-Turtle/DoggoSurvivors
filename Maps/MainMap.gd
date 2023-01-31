extends Node

func _ready():
	AssignSpawnContainer()
	pass

func AssignSpawnContainer():
	LevelManager.SpawnContainer = $ActorContainer
	pass
