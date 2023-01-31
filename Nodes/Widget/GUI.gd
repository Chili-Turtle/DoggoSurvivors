extends CanvasLayer

onready var ExperienceBar = get_node("%ExperienceBar")
onready var FPSLabel = get_node("%FPSLabel")
onready var LvLabel = get_node("%LvLabel")

var CoolDownWidget = preload("res://Nodes/Widget/ItemCoolDownWidget.tscn")

func _ready():
	pass

# just important for queued GUIs
func AddToViewport():
	pass

func _process(delta):
	FPSLabel.text = "FPS: " + String(Engine.get_frames_per_second())
	$"%LevelTime".text = "Time %02d:%02d" %[LevelManager.LevelTimer * 0.01667, fmod(LevelManager.LevelTimer, 60)]
	
#	$"%Debugger".text = OS.get_executable_path().get_base_dir().plus_file("CSVData/WeaponData.csv")
	var filer = File.new()
	var doesExits = filer.file_exists(OS.get_executable_path().get_base_dir().plus_file("CSVData/WeaponData.csv"))
	
	$"%Debugger".text = str(doesExits)
	pass

func OnUpdateExperienceBar(percentExperience : float, curLvl : int):
	ExperienceBar.value = percentExperience * 100
	LvLabel.text = "LV: " + String(curLvl)
	pass

func UpdateValues(_playerStats):
	$DamagePanel.UpdateValues(_playerStats)
	pass

func AddItemToCoolDownPanel(_ItemName, _textureIcon, _CooldownTime):
	var CoolDownWidgetInst = CoolDownWidget.instance()
	CoolDownWidgetInst.InitValues(_textureIcon, _CooldownTime, _ItemName)
	$"%ItemGrid".add_child(CoolDownWidgetInst)
	pass

func RemoveItemFromCoolDownPanel(_ItemName):
	for child in $"%ItemGrid".get_children():
		if child.ItemName == _ItemName:
			child.queue_free()
			pass
		pass
	pass

func UpdateCooldown(_CooldownTime, _CurCooldownTime, _ItemName):
	for child in $"%ItemGrid".get_children():
		if child.ItemName == _ItemName:
			child.UpdateCooldown(_CooldownTime, _CurCooldownTime) 
	pass

func InitLevelProgress(_WaveData):
	$LevelProgress.InitLevelProgress(_WaveData)

func UpdatewaveProgress():
	$LevelProgress.UpdatewaveProgress()
	pass
