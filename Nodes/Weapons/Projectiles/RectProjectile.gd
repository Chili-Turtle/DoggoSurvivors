extends Node2D

onready var PlayerManager = get_tree().root.get_node("PlayerManager")

# Knife values
var speed := 200.0
var InitDirection
var BaseDamage = 0.0
var CollisionRadius = 5.0
var MaxRange = 200.0
var KnockbackAmount = 0.0

# Projectile values
var TravelDistance = 0.0
var DirectionSwitch = 1.0
var TraveTime = 0.0
var TimeBeforeDel = 1.05 # 0.05

# Wall Hit Effect
var CanBounce = true
var BounceWaitTime = 0.0

var FramesResource : SpriteFrames
var AnSpriteScene = preload("res://Nodes/Misc/SelfDeletingAnimatedSprite.tscn")
var SpriteAnimation
var OnHitEffectEnemie
var OnHitEffectWall

var HitList = []

func _ready():
	set_process(true) # FIX don't use process
	
	printerr("rectprojectile: do is use this")
	pass

func Shoot(_speed : float, _direction : Vector2, _texture, _damage, _CollisionRadius, _MaxRange, _KnockbackAmount, _ProjectilePosition, _OnHitEffectEnemie, _OnHitEffectWall):
	# $Sprite.texture = texture
	position = _ProjectilePosition
	position.x += (Vector2(1, 1) * _CollisionRadius).x * _direction.x # Vector2(1, 1) forces the Collision into a vector
	SpriteAnimation = _texture
	speed = _speed
	InitDirection = _direction
	BaseDamage = _damage
	CollisionRadius = _CollisionRadius
	MaxRange = _MaxRange
	KnockbackAmount = _KnockbackAmount
	OnHitEffectEnemie = _OnHitEffectEnemie
	OnHitEffectWall = _OnHitEffectEnemie
	SpawnAnimatedSprite(position, SpriteAnimation)
	
#	look_at(InitDirection)
#	rotation = get_angle_to(InitDirection)
	rotation = deg2rad(-90)
	
#	HitScan()
	pass

func SpawnAnimatedSprite(_ProjectilePosition, Frames):
	var AnSpriteInstance = AnSpriteScene.instance()
	get_parent().add_child(AnSpriteInstance) # add child to GenWeapon at (0, 0)
	AnSpriteInstance.SpawnAnSpriteEffect(_ProjectilePosition, Frames) #SpawnAnSpriteEffect(_position : Vector2, FramesResource : SpriteFrames):
	pass

func HitScan():
	var result = $RectCast.MultiRectCast(position, Vector2(1, 1) * CollisionRadius) # *Vector so its save if Radius is a float
	if !result.empty() and TravelDistance > -1.0: #traven distance for wall clipping projectilese
		for hit in result:
#			if HitList.has(hit.collider):
#				continue
			HitList.append(hit.collider)
			if hit.collider.has_node("Stats/Health"):
				hit.collider.get_node("Stats/Health").TakeDamage(self, BaseDamage)
				hit.collider.KnockBack(KnockbackAmount)

			for HitEffect in OnHitEffectEnemie:
				if HitEffect != null:
					HitEffect.OnHit(result, self, get_parent(), position, InitDirection)

	queue_free()
	pass

func _process(delta):
#	return FIX return don't use process
#	set_as_toplevel(true)
	var result = $RectCast.MultiRectCast(position, Vector2(1, 1) * CollisionRadius) # *Vector so its save if Radius is a float
	
	var distance = speed * delta
#	var motion = InitDirection * distance
	var motion = transform.x * distance

	# follow player type weapon
#	var dir = PlayerManager.PlayerPawn.position - position
#	dir = dir.normalized()
#	position +=  dir * 10 * delta
	position += motion * DirectionSwitch
	TravelDistance += distance
	TraveTime += delta
	
	if !result.empty() and TravelDistance > -1.0: #traven distance for wall clipping projectilese
#		print(result)
#		if is_instance_valid(result[0].collider):
#			if result[0].collider.has_node("Stats/Health"):
#				result[0].collider.get_node("Stats/Health").TakeDamage(self, BaseDamage)
#				result[0].collider.KnockBack(KnockbackAmount)
#				if OnHitEffectEnemie != null:
#					OnHitEffectEnemie.OnHit(result[0].collider)
				# FIXME OnHit
		for hit in result:
#			if is_instance_valid(hit):
			if HitList.has(hit.collider):
				print("double trouble")
				continue
			HitList.append(hit.collider)
			if hit.collider.has_node("Stats/Health"):
				hit.collider.get_node("Stats/Health").TakeDamage(self, BaseDamage)
				hit.collider.KnockBack(KnockbackAmount)
			if !OnHitEffectEnemie.empty():
				for HitEffect in OnHitEffectEnemie:
					HitEffect.OnHit(result, self.filename, get_parent(), position, InitDirection) # FIXME Onhit
				pass
#				if is_instance_valid(self): # what should I do on hit
#					queue_free()
#					pass

			# Wall stuff
#			if result[0].collider.collision_layer == 4: # Static Wall
#				if TravelDistance - BounceWaitTime > 10.0: #safty time for multiple hits (delta 10 just works fine)
#					if CanBounce == true:
##						transform.x = transform.x.bounce($CricleCast.HitInfo["normal"])
#						BounceWaitTime = TravelDistance
#						CanBounce = false
#					else:
#						if is_instance_valid(self):
#							queue_free()
#	queue_free()

	if TravelDistance > MaxRange or TraveTime > TimeBeforeDel:
		if is_instance_valid(self):
			queue_free()
			# on finished distance traveled explode or deal extra demage
			# the further the things travel the more damage it makes (nidalee speer)
			pass
		pass
