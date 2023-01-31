extends Area2D

export var SectionName = ""
onready var ColShape = $CollisionShape2D

func _ready():
	LevelManager.AddLevelSection(self)
	pass
