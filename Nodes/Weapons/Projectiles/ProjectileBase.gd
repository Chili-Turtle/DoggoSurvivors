extends Node2D

class_name Projectile

# Knife values
var speed := 200.0
var InitDirection = false
var BaseDamage = 10.0
var CollisionRadius = 5.0
var MaxRange = 200.0
var KnockbackAmount = 0.0
var MaxAirTime = 2.0
var KnockBackCenterProjectile

# Effects
var OnHitEffectEnemie : Array
var OnHitEffectWall : Array
var SpawnEffects : Array
var OnAirTimeEnd : Array
var OnWeaponAnimationFinished : Array

# Projectile values
var TravelTime = 0.0
var TravelDistance = 0.0
var LastHitTime = 0.0
var DirectionSwitch = 1.0
var HitList = []
var HasStarted = true
var Contact = 0 # FIXME Contact should be in Onhit, but onhit is aresource and which is a global thing (CRAZY THEORY MAXHIT SHOULD BE A WEAPON STAT, AND CONTACT ARE A OK WHERE THERE ARE)
# FIXME have A WeaponsContact VaRIABLE for Weapon hit 3 Times with projectile, spawn super strong projectile
var SelfHit = false
var CollisionMask = [2]
var MaxCollision = 32
var RotateToDirection = true
var Instigator = null
var ProjectileMovement = null
const MaxCountactAmount = 1
var velocity : Vector2
var KnockBackMultiplier = 1.0
var IgnoreAtStart : Array = []

func ResetValues():
	TravelTime = 0.0
	TravelDistance = 0.0
	LastHitTime = 0.0
	DirectionSwitch = 1.0
	HitList = []
	HasStarted = true
	Contact = 0
	Instigator = null
	ProjectileMovement = null
	
	InitDirection = false #HACK remove this if not needed
	pass

func _ready():
	visible = $VisibilityNotifier2D.is_on_screen()
	
	$Sprite.connect("animation_finished", self, "OnAnimationFinished")
	
	$VisibilityNotifier2D.connect("screen_entered", self, "_on_VisibilityNotifier2D_screen_entered")
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	pass
func AssignData(_speed : float, _direction : Vector2, _texture, _damage, _CollisionRadius, _MaxRange, _KnockbackAmount, _ProjectilePosition, _OnHitEffectEnemie, _OnHitEffectWall, _ScaleMultiplier, _HasInitRotation, _SpriteRotation, _Instigator, _CollisionMask, _ProjectileMovement, _AutoStartProjectile, _MaxAirTime, _OnAirTimeEnd, _OnWeaponAnimationFinished, _KnockBackCenterProjectile):
	ResetValues()
	
	
	$Sprite.frames = _texture
	$Sprite.play("default")
	
	# sprite scaling
	if is_instance_valid($Sprite.frames):
		if typeof(_CollisionRadius) == TYPE_VECTOR2:
			# If x is bigger, scale after x else scale after y
			if _texture.get_frame("default", $Sprite.frame).get_size().x > _texture.get_frame("default", $Sprite.frame).get_size().y:
				$Sprite.scale = (Vector2(1, 1) / _texture.get_frame("default", $Sprite.frame).get_size().y) * _CollisionRadius #get_frame
			else:
				printerr(_CollisionRadius)
				$Sprite.scale = (Vector2(1, 1) / _texture.get_frame("default", $Sprite.frame).get_size().x) * _CollisionRadius #get_frame
		else:
			$Sprite.scale = (Vector2(1, 1) / _texture.get_frame("default", $Sprite.frame).get_size().x) * _CollisionRadius
	
	$Sprite.scale *= _ScaleMultiplier # TODO make a ScaleMultilier parameter, so you can adjust the scale of indivudual sprites
#	position = _ProjectilePosition
	position += _ProjectilePosition # Owner = PlayerPawn
	speed = _speed
	InitDirection = _direction
	BaseDamage = _damage
	CollisionRadius = _CollisionRadius
	MaxRange = _MaxRange
	MaxAirTime = _MaxAirTime
	KnockbackAmount = _KnockbackAmount
	OnHitEffectEnemie = _OnHitEffectEnemie
	OnAirTimeEnd = _OnAirTimeEnd
	OnHitEffectWall = _OnHitEffectWall
	OnWeaponAnimationFinished = _OnWeaponAnimationFinished
	SpawnEffects = []
	RotateToDirection = _HasInitRotation
	Instigator = _Instigator
	CollisionMask = _CollisionMask
	ProjectileMovement = _ProjectileMovement
	HasStarted = _AutoStartProjectile
	KnockBackCenterProjectile = _KnockBackCenterProjectile
	IgnoreAtStart.append(Instigator)
	
	if RotateToDirection == true: #for weapons with forward direction
		rotation = Vector2.RIGHT.angle_to(InitDirection)
	$Sprite.rotation = deg2rad(_SpriteRotation)
	
	for SpawnEffect in SpawnEffects:
		SpawnEffect.OnSpawn()
	pass

func _process(delta):
#	set_as_toplevel(true) #can't parent sprite to Entity with this ON

	var TempPosition : Vector2 # saves the last local position so I can convert it to global if deattached

	if HasStarted == false:
		TempPosition = position
		return
	
	# convert local to global first
	self.position = to_global(TempPosition)
	get_parent().remove_child(self)
	LevelManager.SpawnContainer.add_child(self)
	
#	var MoveDir = transform.x * DirectionSwitch
#	var velocity = MoveDir * speed * delta
#	position += velocity

	# >DEBUG DRAW
	if typeof(CollisionRadius) == TYPE_VECTOR2:
		GlobalDraw.DrawRect([position, CollisionRadius, rotation, Color.red])
	else:
		GlobalDraw.DrawCircle([position, CollisionRadius, Color.red])
		#position for global and to_local/to_global(Vector2()) for both
		
#	var result = GameFunctionCast.MultiCircleCast(position, CollisionRadius, CollisionMask, MaxCollision, get_world_2d().direct_space_state, rotation) #(_CastPosition : Vector2, Radius : float, CollisionMask : PoolIntArray, MaxCollisions : int = 32, direct_space_state = null) -> Array:
	var result = GameFunctionCast.MultiCircleCast(to_global(Vector2()), CollisionRadius, CollisionMask, MaxCollision, get_world_2d().direct_space_state, rotation) #(_CastPosition : Vector2, Radius : float, CollisionMask : PoolIntArray, MaxCollisions : int = 32, direct_space_state = null) -> Array:

	# Remove the start overlapping pawn from array
	if IgnoreAtStart.size() >= 0:
		if result.empty() or IgnoreAtStart.has(result[0].collider) == false: # not save and sound (edgecase if Player still in collision and hit enemy, the player get removed from the Ignore list)
			IgnoreAtStart.clear()
			pass
		
#	if !result.empty() and TravelDistance > 10.0:
	if !result.empty(): # should I change this to a loop: for hit in result
		if is_instance_valid(result[0].collider) and !HitList.has(result[0].collider) and IgnoreAtStart.has(result[0].collider) == false:
			
			# is not spawned in player
#			if result[0].collider in IgnoreAtStart:
#				return

			# if the player overlaps with the projectile at spawn do nothing (use a more elegant solution, like on spawn add player to a SpawnHitList and ignore as long he is collising "clear list when not colliding)
			Contact += 1
			HitList.append(result[0].collider)
			
			if result[0].collider.has_node("Stats/Health"):
				result[0].collider.get_node("Stats/Health").TakeDamage(Instigator, BaseDamage)
				
#				velocity += Vector2(10000, 0)
#				speed = 0
#				position += Vector2(position).bounce(result[0].HitInfo.normal) * delta
				
				#Kockback origion
				if KnockBackCenterProjectile == true:
					result[0].collider.KnockBack(self, KnockbackAmount * KnockBackMultiplier)
				else:
					result[0].collider.KnockBack(Instigator, KnockbackAmount * KnockBackMultiplier) # this is stupid / Knockback should be also a node / smart contract

				LastHitTime = TravelTime
				if is_instance_valid(self): # what should I do on hit
					for HitEffect in OnHitEffectEnemie:
						if HitEffect != null: #why is this here -> I don't need to check if I look up elements from an array???
							HitEffect.OnHit(result[0], self, get_parent(), position, InitDirection, Instigator)
							# HitObject, ObjectToSpawn, _Parent, _position, _InitDirection
					pass
	# Assign Velocity from resourc
	if ProjectileMovement != null:
#		var velocity2 = ProjectileMovement.velocity(self, delta, result)
		velocity = ProjectileMovement.velocity(self, delta, result)
		position += velocity * delta
	else:
		velocity = Vector2()
	
	# calc movement direction 
	TravelTime += delta
	TravelDistance += abs(velocity.length() * delta)

	# if projectile stops
	if abs(velocity.length()) <= 0:
#		print("velocity is 0")
		pass

	if abs(LastHitTime - TravelTime) > 0.5: # FIXME this (edge cases)
		if !HitList.empty():
			HitList.pop_front()
	
	if TravelTime > MaxAirTime:
		if is_instance_valid(self):
			# on finished distance traveled explode or deal extra demage
			# the further the things travel the more damage it makes (nidalee speer)
			for AirTimeEffect in OnAirTimeEnd:
				AirTimeEffect.AirTimeEnd(self, position)

			if is_instance_valid(get_parent()) and TravelTime > 240: #Safty after 4 mins delete anyway
				get_parent().remove_child(self)
#			queue_free()
			pass
		pass

	if TravelDistance > MaxRange:
		if is_instance_valid(self):
			# on finished distance traveled explode or deal extra demage
			# the further the things travel the more damage it makes (nidalee speer)
#			queue_free()
			if is_instance_valid(get_parent()):
				get_parent().remove_child(self)
			pass
		pass
	
#	velocity = Vector2()
#	position += velocity * delta
		
	pass

func OnAnimationFinished():
	for WeaponAnimationFinishedEffects in OnWeaponAnimationFinished:
		WeaponAnimationFinishedEffects.WeaponAnimationFinished(self)
	pass

func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	pass # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	pass # Replace with function body.
