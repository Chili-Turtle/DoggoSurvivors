extends CanvasLayer

func _ready():
	get_tree().paused = true
	$"%AnimationPlayer".connect("animation_finished", self, "OnAnimaitonFinished")
	pass

# just important for queued GUIs
func AddToViewport():
	pass

func _on_OpenChest_pressed():
	$"%OpenChest".visible = false
	$"%OpenChest".disabled = true
	$"%AnimationPlayer".play("OpenCestUI")
	
	var RandItem = LevelManager.GetRandomItemFromItemPool()
	var CSVData = GameFunction.readCSV(DataPath.GetItemData())
	if CSVData[RandItem]["ItemType"] == "OnHit":
		var NewResource = load(CSVData[RandItem]["ItemPath"])
		# check all weapons for HitEffect, if has hitEffect upgrade, else add it to weapon
		for weapon in PlayerManager.PlayerPawn.GetAllWeapons(): #  # TODO THIS SHOULD BE IN THE PLAYER GET ALL ONHITEFFECT
			if weapon.CurStats.OnHitEffectEnemie.has(NewResource.ItemName):
				weapon.CurStats.OnHitEffectEnemie.get(NewResource).UpgradeWeapon()
				printerr("New OnHit")
				return
		
			printerr("No weapon has this onhit effect what should I do With the OnHit???")
#			if PlayerManager.PlayerPawn.GetWeapon(RandItem).CurStats.OnHitEffectEnemie.has(NewResource) == false:
#				PlayerManager.PlayerPawn.GetWeapon(RandItem).CurStats.OnHitEffectEnemie.append(NewResource)
	else:
		if PlayerManager.PlayerPawn.HasWeapon(RandItem) == false:
			PlayerManager.PlayerPawn.AddWeapon(RandItem) # AddWeapon(Weapon : Node2D, WeaponName : String):
		else:
			PlayerManager.PlayerPawn.GetWeapon(RandItem).CurStats.UpgradeWeapon()
			printerr("Upgrade Weapon")

	# HACK do i have to remove the item tho?
#	LevelManager.RemoveFromItemPool(RandItem)

	
	pass

func OnAnimaitonFinished(Anim):
	UiManager.RemoveUI(self)
	get_tree().paused = false
	pass
