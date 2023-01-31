extends CanvasLayer

var ItemSlot = preload("res://Nodes/Widget/ItemCardSlot.tscn")

var CurSelectedItem : TextureButton
var CurSelectedWeapon : TextureButton

func _ready():
	# old method of pausing, now in -> AddtoViewport()
#	get_tree().paused = true
#
#	$"%WeaponPanel".visible = false
#	AddItems() # DEBUG STUFF
#	AddWeapons()
	
	# HACK what does this mean? -> old comment->Check the weopon type weapon <- I guess this was a DEBUG To add whip to the item pool
#	var NewItem = ItemSlot.instance()
#	$"%ItemSlotVContaoner".add_child(NewItem)
#	NewItem.connect("pressed", self, "OnItemButtonPressed", [NewItem])
#	var CSVData = GameFunction.readCSV("res://Data/WeaponData.csv")
#	NewItem.InitDataFromCSV(CSVData["Whip"])
	pass

# Important if UI Element is queued
func AddToViewport():
	get_tree().paused = true
	
	$"%WeaponPanel".visible = false
	AddItems() # DEBUG STUFF
	AddWeapons()
	pass

func _on_ConfirmButton_pressed():
	
#	CurSelectedItem
#	CurSelectedWeapon

	# if no weapon selected / there is no weapon to select pass all the checks
	if CurSelectedItem != null:
		var ItemTypes = GameFunction.EWeaponType.get(CurSelectedItem.ItemType)
		match ItemTypes:
			# case OnHit
			GameFunction.EWeaponType.OnHit: # WeaponUpGrade
#				var CSVData = GameFunction.readCSV(DataPath.GetItemData())
				var CSVData
				for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
					if weapon.id == CurSelectedItem.ItemName:
						CSVData = weapon
#				print(CSVData[CurSelectedItem.ItemName]["ItemPath"])
				var NewResource_OnHit = load(CSVData["ItemPath"])
#				var NewResource_OnHit = load(CSVData[CurSelectedItem.ItemName]["ItemPath"])

				# check if Weapons already have the onhit
				var WeaponHasOnHit = false
				for Weapons in PlayerManager.PlayerPawn.GetAllWeapons():
					for Hiteffect in Weapons.CurStats.OnHitEffectEnemie: # TODO THIS SHOULD BE IN THE PLAYER GET ALL ONHITEFFECT
						if Hiteffect.ItemName == NewResource_OnHit.ItemName: #why Do I load a resource I just need the name, load the resource when I don't have a onhiteffect
							WeaponHasOnHit = true
							Hiteffect.LevelUp()
							printerr("already has onhit <-----------------------")
							printerr(Hiteffect.ItemName)
							printerr(NewResource_OnHit.ItemName)
							break
					pass
				if WeaponHasOnHit == false:
					printerr("OnHit gets assigned <-----------------------")
					PlayerManager.PlayerPawn.GetWeapon(CurSelectedWeapon.ItemName).CurStats.OnHitEffectEnemie.append(NewResource_OnHit)
				pass
			#case Weapon
			GameFunction.EWeaponType.Weapon:
				if PlayerManager.PlayerPawn.HasWeapon(CurSelectedItem.ItemName) == true:
					PlayerManager.PlayerPawn.GetWeapon(CurSelectedItem.ItemName).LevelUp()
				else:
					var CSVData
					for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
						if weapon.id == CurSelectedItem.ItemName:
							CSVData = weapon
#					var CSVData = GameFunction.readCSV(DataPath.GetItemData())
#					print(CSVData[CurSelectedItem.ItemName]["ItemPath"])
					var NewResource = load(CSVData["ItemPath"]).instance() # GenWeapon
#					var NewResource = load(CSVData[CurSelectedItem.ItemName]["ItemPath"]).instance() # GenWeapon
					
					# HACK do i have to remove the item tho?, I could check if I reached max level and remove it here
					LevelManager.RemoveFromItemPool(CurSelectedItem.ItemName)
					
					# FIXME if weapon exist check for upgrades
					PlayerManager.PlayerPawn.AddWeapon(CurSelectedItem.ItemName) # AddWeapon(Weapon : Node2D, WeaponName : String):
					pass
			#case Accesorty
			GameFunction.EWeaponType.Accesory:
				pass
			_:
				print("something went wrong pls check you brain out")
	
	# the order is important  otherwise it would not pause
	get_tree().paused = false
	UiManager.RemoveUI(self)
	pass

func AddItems():
	for child in $"%ItemSlotVContaoner".get_children():
		child.queue_free()
	
	for i in range(0, 3): # TODO Max items to display, and rerolls
		var RandomItemName = LevelManager.GetRandomItemFromItemPool()
		if RandomItemName.empty():
			continue
		
		var NewItem = ItemSlot.instance()
		$"%ItemSlotVContaoner".add_child(NewItem)
		NewItem.connect("pressed", self, "OnItemButtonPressed", [NewItem])
		
		# check if player has weapon and sprite/data accordingly
		if PlayerManager.PlayerPawn.HasWeapon(RandomItemName):
			NewItem.InitDataFromWeapon(PlayerManager.PlayerPawn.GetWeapon(RandomItemName))
			printerr("LevelUPGUI: if Item {0}".format({'0' : PlayerManager.PlayerPawn.GetWeapon(RandomItemName).CurStats.SpriteResource}))
		else:
#			var CSVData = GameFunction.readCSV(DataPath.GetItemData())
			var CSVData
			for Weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
				if Weapon.id == RandomItemName:
					CSVData = Weapon
			printerr("LevelUPGUI: {0} name {1}".format({'0' : "CSVData", '1' : RandomItemName}))
#			NewItem.InitDataFromCSV(CSVData[RandomItemName])
			NewItem.InitDataFromCSV(CSVData)
	
	if $"%ItemSlotVContaoner".get_child_count() <= 0:
		$"%ConfirmButton".disabled = false
	pass

# add weapons to the upgrade panel (right pannel)
func AddWeapons():
	for child in $"%VWeaponsContainer".get_children():
		child.queue_free()

	if PlayerManager.PlayerPawn == null:
		printerr("LevelUpGUI no PlayerPawn")
		return

	for Item in PlayerManager.PlayerPawn.GetAllWeapons():
		# Assign Data
		var NewItemSlot = ItemSlot.instance()
		print("its here <<<<<<<<<<<<<<<<<<<<<<<< %s %d" %[Item.CurStats.ItemName, Item.CurStats.CurLevel])
		NewItemSlot.InitDataFromWeapon(Item)
		NewItemSlot.connect("pressed", self, "OnWeaponButtonPressed", [NewItemSlot])
		$"%VWeaponsContainer".add_child(NewItemSlot)
	pass

func OnWeaponButtonPressed(WeaponButton):
	if CurSelectedWeapon != WeaponButton and CurSelectedWeapon != null: # if not same item, deselect last item
		CurSelectedWeapon.pressed = false
		CurSelectedWeapon = WeaponButton
		CheckSelections()
		return
	
	if CurSelectedWeapon == WeaponButton: #if same item, set last item to null
		CurSelectedWeapon = null
		CheckSelections()
		return
		
	CurSelectedWeapon = WeaponButton
	CheckSelections()
	pass

func OnItemButtonPressed(Item):
	if CurSelectedItem != Item and CurSelectedItem != null: # if not same item, deselect last item
		CurSelectedItem.pressed = false
		CurSelectedItem = Item
		
		if is_instance_valid(CurSelectedWeapon):
			CurSelectedWeapon.pressed = false
			CurSelectedWeapon = null
		CheckSelections()
		return

	if CurSelectedItem == Item: #if same item, set last item to null
		CurSelectedItem = null
		CheckSelections()
		return
		
	CurSelectedItem = Item
	CheckSelections()
	pass

func CheckSelections(): #if item type is WeaponOnHitUpgrade, both has to be conformed
	if CurSelectedItem == null:
		$"%ConfirmButton".disabled = true
		$"%WeaponPanel".visible = false
		return
	
	var ItemTypes = GameFunction.EWeaponType.get(CurSelectedItem.ItemType)
	match ItemTypes:
		# case OnHit
		GameFunction.EWeaponType.OnHit: # WeaponUpGrade
			# If Upgrade is selected, show panel
			$"%WeaponPanel".visible = true
			
			if CurSelectedItem != null and CurSelectedWeapon != null: # can confirm
				$"%ConfirmButton".disabled = false
			else:
				$"%ConfirmButton".disabled = true

		#case Weapon
		GameFunction.EWeaponType.Weapon:
			# If Upgrade is selected, show panel
			$"%WeaponPanel".visible = false
			$"%ConfirmButton".disabled = false

		#case Accesorty
		GameFunction.EWeaponType.Accesory:
			$"%ConfirmButton".disabled = false
			$"%WeaponPanel".visible = false
		_:
			print("something went wrong pls check you brain out")
	pass
