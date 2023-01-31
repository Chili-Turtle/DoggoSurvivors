extends Node2D

# export
export (bool)var DrawDebugShape = true
export (Array, int) var CollisionMask
export var MaxCollisions : int = 32

# local vars
var DrawRadius : float
var DrawPosition : Vector2

var ShapeTween = Tween.new()

var HitInfo = {}

func _ready():
	add_child(ShapeTween)
	set_process(false)
	pass

func UpdateDrawing():
	if !DrawDebugShape == false:
		update() # this calls the draw function (this is retared, at leat call it update_draw)

	if CollisionMask.size() == 0:
		push_error("No CollisionMask assigned on the RectangleCast, can't detect shapes this way")
		pass
	pass

func MultiCircleCast(_CastPosition : Vector2, Radius : float) -> Array: #if Circlecast is a child of a 2D node => _CastPos == local position (mostly Vector2(0, 0)
	UpdateDrawing()
	
	DrawRadius = Radius
	DrawPosition = _CastPosition
	
	if !DrawDebugShape == false:
		ShapeTween.interpolate_property(self, "DrawRadius", DrawRadius, 0.0, 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
		ShapeTween.reset(self, "DrawRadius")
		ShapeTween.start()

	var CircleShape = CircleShape2D.new()
	CircleShape.radius = Radius
	
	var query := Physics2DShapeQueryParameters.new()
	var direct_space_state := get_world_2d().direct_space_state
	query.set_shape(CircleShape)
	query.collision_layer = CalcDecimalBitMask(CollisionMask)
	query.collide_with_bodies = true # Kinematic bodies
	query.collide_with_areas = true # Areas
	query.transform = Transform2D(0, _CastPosition)
	
	var result = direct_space_state.intersect_shape(query, MaxCollisions)

	if !result.empty():
		for hit in result:
#			HitInfo = get_world_2d().direct_space_state.get_rest_info(query)
			hit["HitInfo"] = get_world_2d().direct_space_state.get_rest_info(query)

	return result
	pass

func CalcDecimalBitMask(Bitmask : Array):
	var ComputedMask : int
	for bit in Bitmask:
		ComputedMask += pow(2, bit -1)
	return ComputedMask
	pass

func _draw():
	if DrawDebugShape == false:
		return

	var pos = Vector2() # DrawPosition
	var rad = DrawRadius / owner.scale.x
	var col = Color(0.5, 0.1, 0.1, 0.2)
	draw_circle(pos, rad, col)
	pass

func StupidCast(_CastPosition : Vector2, Radius : float) -> Array:
	
	var area = Area2D.new()
	var col = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	area.collision_mask = 1
	area.collision_layer = 4
	area.monitoring = true
	area.monitorable = true
	area.add_child(col)
	area.position = _CastPosition
	
	#shape.set_radius(Radius)
	shape.radius = Radius
	col.shape = shape
	
	get_tree().root.add_child(area)
	yield(get_tree().create_timer(0.05),"timeout") #wait for next frame otherwise bug
	print(area.get_overlapping_bodies())
	
	#if area.get_overlapping_bodies().size() != 0:
		#print(area.get_overlapping_bodies()[0])
		
	return area.get_overlapping_bodies().size()
