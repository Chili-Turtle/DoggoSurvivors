extends TextureProgress

var ItemName = ""

func _ready():
	pass

func InitValues(_textureIcon, _CooldownTime, _ItemName):
	ItemName = _ItemName
	texture_under = _textureIcon
#	texture_progress = _textureIcon #TODO Make Weapon Icons
	max_value = _CooldownTime
	value = 0.0
	pass

func UpdateCooldown(_CooldownTime, _CurCooldownTime):
	max_value = _CooldownTime
	value = _CurCooldownTime
	pass
