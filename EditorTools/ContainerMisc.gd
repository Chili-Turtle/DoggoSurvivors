tool
extends Container

enum SizeFlags {SIZE_FILL = 1, SIZE_EXPAND = 2, SIZE_EXPAND_FILL = 3, SIZE_SHRINK_CENTER = 4, SIZE_SHRINK_END = 8}
enum VALIGN {TOP = 0, CENTER = 1, BOTTOM = 2, FILL = 3}
enum ALIGN {TOP = 0, CENTER = 1, BOTTOM = 2, FILL = 3}

export var MinSize : Vector2 setget set_MinSize
export(SizeFlags) var ChildrenSizeFlag setget set_ChildrenSizeFlag
export(VALIGN) var TextVAlignment setget set_TextVAlignment
export(ALIGN) var TextAlignment setget set_TextAlignment

func set_MinSize(value):
	MinSize = value
	for child in get_children():
		print(get("rect_min_size123"))
		child.rect_min_size = MinSize
		print(child)
	pass

func set_ChildrenSizeFlag(value):
	for child in get_children():
		child.size_flags_horizontal = value
	ChildrenSizeFlag = value
	pass

func set_TextVAlignment(value):
	for child in get_children():
		if child.get("TextVAlignment") != null or child.get("valign") != null:
			child.valign = value
	TextVAlignment = value
	pass

func set_TextAlignment(value):
	for child in get_children():
		if child.get("TextAlignment") != null or child.get("align") != null:
			child.align = value
	TextAlignment = value
	pass
