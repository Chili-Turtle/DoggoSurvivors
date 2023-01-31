extends Control

var DebugTime = 120.0

var FakeTimes = [15, 30, 60, 120]

var SpriteSize = Vector2(40, 40)


var MaxWaveTime = 0.0

# rect_size.x = 100%
# var DebugTime = 100%
func _ready():
#	$HBoxContainer/ColorRect/TextureProgress.value = 30/DebugTime
#	for time in FakeTimes:
#		var perncet = time / DebugTime
#		var IconXPos = rect_size.x * perncet
#		var icon = TextureRect.new()
#		add_child(icon)
#		icon.expand = true
#		icon.grow_vertical
#		icon.texture = load("res://Themes/TB_Hovered.tres")
#		icon.rect_position = Vector2(IconXPos-(SpriteSize.x/2), 12)
#		icon.rect_size = SpriteSize
#		#spawn image
#		pass
	pass

func UpdatewaveProgress():
	$"%TextureProgress".value = LevelManager.LevelTimer / MaxWaveTime
	pass

func InitLevelProgress(_WaveData):
	# get waves -2 the last wave is a dummy wave with a unreasanable high time
	var WavesAmount = _WaveData.size() - 2
#	var WavesAmount = _WaveData.values().size() - 2
	MaxWaveTime = float(_WaveData[WavesAmount]["NextWaveTimer"])
#	MaxWaveTime = float(_WaveData.values()[WavesAmount]["NextWaveTimer"])
	
	# exception for last dummy wave
#	for waveTimer in _WaveData.values():
	for waveTimer in _WaveData:
		if float(waveTimer["NextWaveTimer"]) == 999.0:
			break
			
		var CurTime = waveTimer["NextWaveTimer"]
		
		# current timer divided by last timer
		var percent = float(CurTime) / MaxWaveTime

		var IconXPos = rect_size.x * percent
		
		#set icon
		var icon1 = TextureRect.new()
		add_child(icon1)
		icon1.expand = true
		icon1.grow_vertical
		icon1.texture = load("res://Themes/TB_Hovered.tres")
		icon1.rect_position = Vector2(IconXPos-(3/2), 0)
		icon1.rect_size = Vector2(3, 74)
		pass

		#set icon
		var icon = TextureRect.new()
		add_child(icon)
		icon.expand = true
		icon.grow_vertical
		var WaveTexture : StreamTexture
		WaveTexture = load(waveTimer["Icon"])
		icon.texture = WaveTexture
		icon.self_modulate = Color.red
		icon.rect_position = Vector2(IconXPos-(SpriteSize.x/2), 12)
		icon.rect_size = SpriteSize
	pass
