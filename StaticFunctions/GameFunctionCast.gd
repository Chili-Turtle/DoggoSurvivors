extends Node2D

class_name GameFunctionCast

# -------- Casting ----------
static func MultiCircleCast(_CastPosition : Vector2, CollisioArea, CollisionMask : PoolIntArray, MaxCollisions : int = 32, direct_space_state = null, _rotation = 0) -> Array: #if Circlecast is a child of a 2D node => _CastPos == local position (mostly Vector2(0, 0)
	
	var ColShape
	if typeof(CollisioArea) == TYPE_VECTOR2:
		ColShape = RectangleShape2D.new()
		ColShape.extents = CollisioArea
#		GlobalDraw.DrawRect([_CastPosition,CollisioArea, Color.red])
	else:
		ColShape = CircleShape2D.new()
		ColShape.radius = CollisioArea
#		GlobalDraw.DrawCircle([_CastPosition, CollisioArea, Color.green])
	
	var query := Physics2DShapeQueryParameters.new()
	query.set_shape(ColShape)
	query.collision_layer = DecimalsToBitMask(CollisionMask)
	query.collide_with_bodies = true # Kinematic bodies
	query.collide_with_areas = true # Areas
	query.transform = Transform2D(_rotation, _CastPosition)

	var result = direct_space_state.intersect_shape(query, MaxCollisions) #[{collider:Enemy:[KinematicBody2D:1626], collider_id:1626, metadata:Null, rid:[RID], shape:0}]

	if !result.empty():
		for hit in result:
			hit["HitInfo"] = direct_space_state.get_rest_info(query) # [{collider:Enemy:[KinematicBody2D:1626], collider_id:1626, metadata:Null, rid:[RID], shape:0}]
			pass

	return result
	pass

static func DecimalsToBitMask(Bitmask : Array):
	var ComputedMask : int
	for bit in Bitmask:
		ComputedMask += pow(2, bit -1)
	return ComputedMask
	pass

	pass
