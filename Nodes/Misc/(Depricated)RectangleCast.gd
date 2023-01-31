extends Node2D

export (bool)var DrawDebugShape = true

export (Array, int) var CollisionMask
export var MaxCollisions : int = 32

var DrawExtends : Vector2
var DrawPosition : Vector2

var ShapeTween = Tween.new()

func _ready():
	add_child(ShapeTween)
	pass

func UpdateDrawing():
	if !DrawDebugShape == false:
		update() # this calls the draw function (this is retared, at leat call it update_draw)
	
	if CollisionMask.size() == 0:
		push_error("No CollisionMask assigned on the RectangleCast, can't detect shapes this way")
		pass
	pass

func MultiRectangleCast(_CastPosition : Vector2, Extends : Vector2):
	UpdateDrawing()
	
	DrawExtends = Extends
	DrawPosition = _CastPosition
	
	if !DrawDebugShape == false:
		ShapeTween.interpolate_property(self, "DrawExtends", DrawExtends, Vector2(0.0, 0.0), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
		ShapeTween.reset(self, "DrawExtends")
		ShapeTween.start()
	
	# set the area, and the shape/shape size/add the shape to the area
	var RectangleArea = Physics2DServer.area_create()
	Physics2DServer.area_set_space(RectangleArea, get_world_2d().space)
	
	var RectangleShape = Physics2DServer.rectangle_shape_create()
	
	Physics2DServer.shape_set_data(RectangleShape, Extends) #add shape % size
	Physics2DServer.area_add_shape(RectangleArea, RectangleShape) #assign shape to RectangleArea
	Physics2DServer.area_set_monitorable(RectangleArea, true)
	
	Physics2DServer.area_set_collision_mask(RectangleArea, 1)
	
	# query this is the meat and potatoes of the whole thing, you can set the position and collision layer
	var query = Physics2DShapeQueryParameters.new()
	var space = Physics2DServer.area_get_space(RectangleArea) # could I use world_2D().space
	var space_state = Physics2DServer.space_get_direct_state(space) # all the intersection
	
	query.transform = Transform2D(0, _CastPosition)
#	query.transform = Transform2D(0, _CastPosition + Vector2(Extends.x * 0.5 , 0.0)) # transfrom = left_center, you can't decide direction that way if you want't this class just a a pure casting class
	#query.collide_with_areas = true
	#query.collide_with_bodies = true
	
	query.collision_layer = CalcDecimalBitMask(CollisionMask)
	query.shape_rid = RectangleShape
	
	var result = space_state.intersect_shape(query, MaxCollisions)
	return result
	pass

func BetterQuery_code():
	UpdateDrawing()
	DrawExtends = Vector2(10, 20)
	DrawPosition = PlayerManager.get_PlayerPawn().position
	
	# if !DrawDebugShape == false:
	# 	ShapeTween.interpolate_property(self, "DrawExtends", DrawExtends, Vector2(0.0, 0.0), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	# 	ShapeTween.reset(self, "DrawExtends")
	# 	ShapeTween.start()

	var RectShape = RectangleShape2D.new()
	RectShape.extents = Vector2(10, 20)

	var query := Physics2DShapeQueryParameters.new()
	var direct_space_state = PlayerManager.get_PlayerPawn().get_world_2d().direct_space_state
	query.set_shape(RectShape)
	query.collide_with_bodies = true
	query.collision_layer = CalcDecimalBitMask(CollisionMask)
	# query.transform = Transform2D(0, PlayerManager.get_PlayerPawn().position)
	# query.transform = Transform2D(0, _CastPosition)
	var result = direct_space_state.intersect_shape(query, 1)
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
	
	var pos = to_local(DrawPosition)
	var ext = DrawExtends
	var col = Color(0.5, 0.1, 0.1, 0.2)
	draw_rect(Rect2(pos - DrawExtends, DrawExtends*2), col)
	# draw_rect(Rect2(pos - Vector2(-ext.x * 0.5, ext.y), ext * 2.0), col) # start rec of draw is top_left, while spawning is in the middle (local Vector2(0, 0)
	pass

func StupidCast(_CastPosition : Vector2, Radius : float) -> Array:
	
	var area = Area2D.new()
	var col = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
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
