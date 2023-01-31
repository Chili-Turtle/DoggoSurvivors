extends BossAttack
class_name BossAttack8WayBullet

func StartAttack(_position, _Instigator):
#	var CSVDATA = GameFunction.readCSV(DataPath.GetItemData())
	var CSVDATA
	for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		if weapon.id == "":
			pass
	var Weapon = GameFunction.SpawnActor(load("res://Nodes/Weapons/GeneratedWeapons/ProjectileSpawner.tscn"), Vector2(), 0, Vector2(1, 1), _Instigator, _Instigator)
	Weapon.Instigator = _Instigator
	Weapon.CurStats.AssignBaseStats("8WayBulletHell", false)
	for i in range(1, _Instigator.Level):
		Weapon.CurStats.UpgradeWeapon()
		printerr("bullet hell is upgraded")	
	Weapon.connect("AttackFinished", self, "OnAttackFinished")
	pass

func OnAttackFinished():
	emit_signal("AttackFinished")
	pass
