extends BossAttack

class_name BossAttackWindScar

func StartAttack(_position, _Instigator):
	var CSVDATA
	for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		pass
#
#	if OS.get_name() == 'HTML5':
#		CSVDATA = GameFunction.readJson('res://CSVData/WeaponData.json')
#		pass
#	else:
#		CSVDATA = GameFunction.readCSV(DataPath.GetItemData())
#		pass
	
	var Weapon = GameFunction.SpawnActor(load("res://Nodes/Weapons/GeneratedWeapons/ProjectileSpawner.tscn"), Vector2(), 0, Vector2(1, 1), _Instigator, _Instigator)
	Weapon.Instigator = _Instigator
	Weapon.CurStats.AssignBaseStats("WindScar", false)
	for i in range(1, _Instigator.Level):
		Weapon.CurStats.UpgradeWeapon()
		printerr("Windsacr is upgraded")
	
	Weapon.CurStats.ProjectileAmount
	Weapon.connect("AttackFinished", self, "OnAttackFinished")
	pass

func OnAttackFinished():
	emit_signal("AttackFinished")
	pass
