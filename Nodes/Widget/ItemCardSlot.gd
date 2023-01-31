extends TextureButton

var ItemLevel : int
var ItemName : String
var ItemIcon
var ItemType : String
var ItemDescription : String

func InitDataFromWeapon(Item):
	ItemIcon = Item.CurStats.SpriteResource.get_frame("default", 0)
	ItemLevel = Item.CurStats.CurLevel # get that from the weapon
	ItemDescription = Item.CurStats.ItemDescription
	ItemName = Item.CurStats.ItemName
	ItemType = Item.CurStats.ItemType
	
	UpdateUI()
	pass

func InitDataFromCSV(Item):
	var file = str(Item["SpriteFiles"])
	if file.get_extension() in ["png", 'PNG', 'jpg', 'JPG']:
		ItemIcon = load(Item["SpriteFiles"])
	else: #othewise its an folder
		var dir = Directory.new()
		dir.open(Item["SpriteFiles"])
		dir.list_dir_begin(true)
		var CurImage = dir.get_next()
		if CurImage != '':
			ItemIcon = load(dir.get_current_dir() + "/" + CurImage)

	ItemLevel = 1 # get that from the weapon
	ItemDescription = Item["ItemDescription"]
	ItemName = Item["WeaponName"]
	ItemType = Item.ItemType
	
	UpdateUI()
	pass

func UpdateUI():
	$"%WeaponIcon".texture = ItemIcon
	$"%ItemLevel".text = "Level: %d" %ItemLevel # get that from the weapon
	$"%ItemDescription".text = ItemDescription
	$"%ItemName".text = ItemName
	ItemType = ItemType
	pass

