extends Node2D

var DataArrayCircle : Array
var DataArrayRect : Array

export var Transparency = 0.2

var TimeDraw = 0.0

func DrawCircle(Data : Array):
#	if DataArrayCircle.size() <= 10000:
	DataArrayCircle.append(Data)
	pass

func DrawRect(Data : Array): #([position, CollisionRadius, rotation, Color.red])
#	if DataArrayRect.size() <= 1000:
	DataArrayRect.append(Data)
	pass

func _process(delta):
	if DataArrayCircle.size() + DataArrayRect.size() <= 0:
		return
	update()
	pass

func _draw():
	return
	for Data in DataArrayCircle:
		draw_circle(Data[0], Data[1], Color(Data[2].r, Data[2].g, Data[2].b, Transparency))
		pass
#	draw_circle(Vector2((1920) * 0.5 ,1080/2), 100, Color.rebeccapurple)
	
	for Data in DataArrayRect:
		draw_set_transform(Data[0], Data[2], Vector2(2, 2))
#		draw_set_transform(Vector2(1920/2, 1080/2), Data[2] , Vector2(6, 6)) #For 1080,1080
		
		draw_rect(Rect2((Vector2(0,0) - Data[1] / 2), Data[1]), Color(Data[3].r, Data[3].g, Data[3].b, Transparency))
#		draw_rect(Rect2((Data[1] / 2) * 1.7777, Data[1]), Color(Data[3].r, Data[3].g, Data[3].b, Transparency)) # for 1080, 1080
		
#		draw_rect(Rect2(Data[0] - Data[1], Data[1] * 2), Color(Data[2].r, Data[2].g, Data[2].b, Transparency))
	
	DataArrayCircle.clear()
	DataArrayRect.clear()
	pass
