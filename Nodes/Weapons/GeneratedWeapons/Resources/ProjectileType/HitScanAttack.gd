class_name HitScanAttack
extends WeaponAttack

var projectile = preload("res://Nodes/Weapons/Projectiles/RectProjectile.tscn")

# export var HitBox = Vector2(20, 30)

# onready var AttackCaster = preload("res://Nodes/Misc/RectangleCast.gd")
# var SquareCastNode2D

func _ready():
	# SquareCastNode2D.DrawDebugShape(true)
	pass
	
# func initResource():
# 	SquareCastNode2D = Node2D.new()
# 	SquareCastNode2D.script = load("res://Nodes/Misc/RectangleCast.gd")
# 	PlayerManager.get_PlayerPawn().get_node("WeaponHolster").add_child(SquareCastNode2D)
# 	SquareCastNode2D.owner = PlayerManager.get_PlayerPawn()

# 	SquareCastNode2D.position = PlayerManager.get_PlayerPawn().position
	

# 	# SquareCastNode2D = AttackCaster.instanced() # (_CastPosition : Vector2, Extends : Vector2):

# 	SquareCastNode2D.BetterQuery_code()
# 	pass

# # should I have the spawn logic in the projectile thing
# func HitZone(Attckposition):
# 	SquareCastNode2D.MultiRectangleCast(Attckposition, HitBox)
# 	pass
