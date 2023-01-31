extends Node2D

var BulletSprite = preload("res://icon.png")

#onready var PlayerManager = get_tree().root.get_node("PlayerManager")

# Knife values
var speed := 200.0
var InitDirection
var BaseDamage = 10.0
var CollisionRadius = 5.0
var MaxRange = 200.0
var KnockbackAmount = 0.0

# Projectile values
var TravelDistance = 0.0
var DirectionSwitch = 1.0

# Wall Hit Effect
var CanBounce = true
var BounceWaitTime = 0.0

# Enemy Hit Effect
var OnHitEffectEnemie
var OnHitEffectWall

var HitList = []
var TraveTime = 0.0
var TimeBeforeDel = 5.00
var LastHitTime = 0.0

var Contact = 0
var MaxCountactAmount = 1

func _ready():
	printerr("StraightProjectile, Do I use this? <----------------------")
	pass

func Shoot(_speed : float, _direction : Vector2, _texture, _damage, _CollisionRadius, _MaxRange, _KnockbackAmount, _ProjectilePosition, _OnHitEffectEnemie, _OnHitEffectWall):
	$Sprite.texture = _texture # should that not be parent.texture or something
	$Sprite.scale = (Vector2(1, 1) / _texture.get_size().x) * _CollisionRadius
	
	print($Sprite.texture.get_size())
	position = _ProjectilePosition # Owner = PlayerPawn
	speed = _speed
	InitDirection = _direction
	BaseDamage = _damage
	CollisionRadius = _CollisionRadius
	MaxRange = _MaxRange
	KnockbackAmount = _KnockbackAmount
	OnHitEffectEnemie = _OnHitEffectEnemie
	OnHitEffectWall = _OnHitEffectWall
	
	rotation = Vector2.RIGHT.angle_to(InitDirection)
	pass

func _process(delta):
#	set_as_toplevel(true)
	var result = $CricleCast.MultiCircleCast(position, CollisionRadius)
	
	var distance = speed * delta
#	var motion = InitDirection * distance
	var motion = transform.x * distance

	# follow player type weapon
#	var dir = PlayerManager.PlayerPawn.position - position
#	dir = dir.normalized()
#	position +=  dir * 10 * delta
	position += motion * DirectionSwitch
	TravelDistance += abs(distance)
	TraveTime += delta
	
	if !result.empty() and TravelDistance > 10.0:
		if is_instance_valid(result[0].collider) and !HitList.has(result[0].collider):
			HitList.append(result[0].collider)
			if result[0].collider.has_node("Stats/Health"):
				result[0].collider.get_node("Stats/Health").TakeDamage(self, BaseDamage)
				result[0].collider.KnockBack(KnockbackAmount)
				Contact += 1
				LastHitTime = TraveTime
				
				if is_instance_valid(self): # what should I do on hit
					for HitEffect in OnHitEffectEnemie:
						if HitEffect != null:
							HitEffect.OnHit(result[0], self, get_parent(), position, InitDirection)
						# FIXME OnHitEffect
					
#					queue_free()
					pass
			
			if result[0].collider.collision_layer == 4: # Static Wall
				if TravelDistance - BounceWaitTime > 10.0: #safty time for multiple hits (delta 10 just works fine)
					if CanBounce == true:
#						transform.x = transform.x.bounce($CricleCast.HitInfo["normal"])
						BounceWaitTime = TravelDistance
						CanBounce = false
					else:
						if is_instance_valid(self):
#							queue_free()
							pass

	# safety so the hit detection takes place every 0.5 second for the same enemy
	if abs(LastHitTime - TraveTime) > 0.5: # FIXME this (edge cases)
		if !HitList.empty():
			HitList.pop_front()

	if TravelDistance > MaxRange or TraveTime > TimeBeforeDel:
		if is_instance_valid(self):
			# on finished distance traveled explode or deal extra demage
			# the further the things travel the more damage it makes (nidalee speer)
			queue_free()
		pass
