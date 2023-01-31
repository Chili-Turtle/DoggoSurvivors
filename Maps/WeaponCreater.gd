extends Control

# this should probably be the root node

var AccountSkillPoints : int = 50

onready var WeaponAttackOption = $Panel/VBoxContainer/Option1/WeaponAttackOption
onready var DamageValue = $Panel/VBoxContainer/Option6/DamageValue

onready var Player_Dummy = $"../../Player"

var textureRes : Texture = preload("res://NewGradient2D.tres")

var WeaponGen = preload("res://Nodes/Weapons/GeneratedWeapons/GeneratedWeapon.tscn")

func _ready():
	
	AddItemsToOptions()
	ConnectSignals()
	
	AddOptionValues()
	ConnectOptions()
	
	$Panel/VBoxContainer/Option3/VBoxContainer/ItemList.add_item("Bounce")
	$Panel/VBoxContainer/Option3/VBoxContainer/ItemList.add_item("Paint")
	
	$Panel/VBoxContainer/Option3/VBoxContainer/HBoxContainer/Button.connect("button_down", self, "Test")
	$Panel/VBoxContainer/Option3/VBoxContainer/HBoxContainer/Button2.connect("button_down", self, "RemoveItem")
	
	var WeaponGenInstance = WeaponGen.instance()
	Player_Dummy.AddWeapon(WeaponGenInstance, "Whip")
	pass

func Test():
	$Panel/VBoxContainer/Option3/VBoxContainer/ItemList.add_item("New Item")
	pass
	
func RemoveItem():
	var selectedItems = $Panel/VBoxContainer/Option3/VBoxContainer/ItemList.get_selected_items()
	if selectedItems.size() > 0:
		$Panel/VBoxContainer/Option3/VBoxContainer/ItemList.remove_item(selectedItems[0])
	pass

func ConnectOptions():
	WeaponAttackOption.connect("item_selected", self, "OnWeaponAttackOptionChanged")
	DamageValue.connect("changed", self, "")
	pass

func AddOptionValues():
	WeaponAttackOption.add_item("None")
	WeaponAttackOption.add_item("Hit Scan")
	WeaponAttackOption.add_item("Projectile")
	OnWeaponAttackOptionChanged(WeaponAttackOption.selected)
	pass


func OnWeaponAttackOptionChanged(value):
	#WeaponAttackOption.get_item_text()
	print(WeaponAttackOption.get_item_text(value))
	pass








onready var AttackTypeOption = $"%AttackTypeOption"
onready var SpawnPositionOption = $"%SpawnPositionOption"
onready var OnHitWallOption = $"%OnHitWallOption"
onready var OnHitEnemies = $"%OnHitEnemies"

func ConnectSignals():
	AttackTypeOption.connect("item_selected", self, "OnAttackTypeOptionItemSelected")
	pass
	
func AddItemsToOptions():
	AttackTypeOption.add_item("Hit Scan")
	AttackTypeOption.add_item("Peojectile")
	
	SpawnPositionOption.add_item("8 Way Direction")
	SpawnPositionOption.add_item("Circular")
	
	OnHitWallOption.add_item("None")
	OnHitWallOption.add_item("Bounce")
	
	OnHitEnemies.add_item("None")
	OnHitEnemies.add_item("Bounce")
	OnHitEnemies.add_item("Blitz")
	pass
