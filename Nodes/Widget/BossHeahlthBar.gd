extends CanvasLayer

func _ready():
	pass

func AddToViewport():
	pass

func UpdateHealth(HealthPercent):
	$"%ProgressBar".value = HealthPercent
	pass

func SetName(_BossName):
	$"%BossName".text = _BossName
	pass
