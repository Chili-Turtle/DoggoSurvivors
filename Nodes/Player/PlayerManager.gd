extends Node

var myArr : Array
var PlayerPawn : KinematicBody2D
#onready var navmesh : NavigationPolygonInstance = $MainMap/NavigationPolygonInstance

func _ready():
	var MyTimer = Timer.new()
	add_child(MyTimer)
	MyTimer.connect("timeout", self, "OnGameBegin")
	MyTimer.start(0.1)
