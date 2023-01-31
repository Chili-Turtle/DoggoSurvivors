extends Node2D

export (bool)var DrawDebugShape = true

export (Array, int) var CollisionMask
export var MaxCollisions : int = 32

var DrawExtends : Vector2
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

func MultiRectCast(_CastPosition : Vector2, Radius : Vector2) -> Array:
	UpdateDrawing()

	DrawExtends = Radius
	DrawPosition = _CastPosition
	
	if !DrawDebugShape == false:
		ShapeTween.interpolate_property(self, "DrawExtends", DrawExtends, Vector2(0.0, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
		ShapeTween.reset(self, "DrawExtends")
		ShapeTween.start()

	var RectShape = RectangleShape2D.new()
	RectShape.extents = Radius

	var query := Physics2DShapeQueryParameters.new()
	var direct_space_state = PlayerManager.get_PlayerPawn().get_world_2d().direct_space_state
	query.set_shape(RectShape)
	query.collision_layer = CalcDecimalBitMask(CollisionMask)
	query.collide_with_bodies = true
	query.collide_with_areas = true
	query.transform = Transform2D(0, _CastPosition)
	
	var result = direct_space_state.intersect_shape(query, MaxCollisions)
	
	if !result.empty():
		HitInfo = get_world_2d().direct_space_state.get_rest_info(query)

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
	
	var pos = to_local(DrawPosition)
	var ext = DrawExtends
	var col = Color(0.5, 0.1, 0.1, 0.2)
	draw_rect(Rect2(pos - DrawExtends, DrawExtends*2), col)
	# draw_rect(Rect2(pos - Vector2(-ext.x * 0.5, ext.y), ext * 2.0), col) # start rec of draw is top_left, while spawning is in the middle (local Vector2(0, 0)
	pass
