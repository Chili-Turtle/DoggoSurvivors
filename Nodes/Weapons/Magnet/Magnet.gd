extends Node2D

onready var CircleCast = $CircleCast
onready var MagnetTimer = $Timer

var CurStats : Resource # FIXME help
# FIXME help
# FIXME help
# FIXME help
# FIXME help
# FIXME help



var MagnetRange = 50

func _ready():
	MagnetTimer.connect("timeout", self, "Cast")
	pass

func Cast():
	for hit in CircleCast.MultiCircleCast(owner.position, MagnetRange):
		if is_instance_valid(hit.collider):
			if hit.collider is PickUp:
				hit.collider.OnStartPickUp()
				pass
			pass
	pass
