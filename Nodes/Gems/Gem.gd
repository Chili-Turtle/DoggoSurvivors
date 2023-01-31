extends PickUp

export var ItemName = "Blue Gem"

func _ready():
	InitData(ItemName)
	pass

func OnStartPickUp(): # call it start collection
	.OnStartPickUp()
	pass

func OnPickUp():
	if PlayerManager != null:
		PlayerManager.PlayerPawn.get_node("Stats/Experience").AddExperience(Value)

	SoundManager.PlaySound(SoundFile, -5, 1, -1, "Gem") # (AudioSource, Volume, pitch, priority, ComboName = ""):

	.OnPickUp() # parent pickup
	pass
