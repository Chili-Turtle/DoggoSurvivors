extends Resource

class_name PlayerStats

# -------------  BaseStats -------------
var PlayerLevel : int = 1
var CharacterName : String
var CurHealth : float
var AMaxHealth : float
var CurExperience : float
var NextLvLExperience : float = 5.0
var ADamageMultiplier : float
var AMovementSpeed : float
var AProjectileAmount : int
var AAreaMultiplier : float
var ACooldownMultiplier : float
var AExperienceMultiplier : float
var HealthRegen : float
var ProjectileSpeed : float = 1.0
var KnockBack : float = 1.0
var StartWeapons : Array
# -------------  Additional Stats -------------
var AddMaxHealth : float = 0.0
var AddDamageMultiplier : float = 0.0
var AddMovementSpeed : float = 0.0
var AddProjectileAmount : int = 0
var AddAreaMultiplier : float = 0.0
var AddCooldownMultiplier : float = 0.0
var AddExperienceMultiplier : float = 0.0
var AddHealthRegen : float = 0.0
var AddProjectileSpeed : float = 0.0
var AddKnockBack : float = 0.0

# ------------- growth data -----------
var MaxHealthGrowth : Array
var DamageMultiplierGrowth : Array
var MovementSpeedGrowth : Array
var ProjectileAmountGrowth : Array
var ProjectileSpeedGrowth : Array
var AreaMultiplierGrowth : Array
var CooldownMultiplierGrowth : Array
var ExperienceMultiplierGrowth : Array
var HealthRegenGrowth : Array
var KnockBackGrowth : Array

var BaseStatsCSV : Dictionary

func AssignBaseStats(_CharacterName = "Jeff"): # caches the base stats
	
#	if OS.get_name() == 'HTML5':
#		for CharacterStats in GameFunction.readJson('res://CSVData/CharacterBaseStats.json'):
#			if CharacterStats.id == _CharacterName:
#				BaseStatsCSV = CharacterStats
#	else:
#		BaseStatsCSV = GameFunction.readCSV(DataPath.GetPlayerData())[_CharacterName]
#		pass
	
	for CharacterStats in GameFunction.readJson('res://CSVData/CharacterBaseStats.json'):
		if CharacterStats.id == _CharacterName:
			BaseStatsCSV = CharacterStats
	
	CharacterName = str(BaseStatsCSV["CharacterName"])
	AMaxHealth = float(BaseStatsCSV["Health"])
	AMovementSpeed = float(BaseStatsCSV["MovementSpeed"])
	ADamageMultiplier = float(BaseStatsCSV["DamageMultiplier"])
	AProjectileAmount = int(BaseStatsCSV["ProjectileAmount"])
	ProjectileSpeed = float(BaseStatsCSV["ProjectileSpeed"])
	AAreaMultiplier = float(BaseStatsCSV["AreaMultiplier"])
	ACooldownMultiplier = float(BaseStatsCSV["CooldownMultiplier"])
	AExperienceMultiplier = float(BaseStatsCSV["ExperienceMultiplier"])
	KnockBack = float(BaseStatsCSV["Kockback"])
	HealthRegen = float(BaseStatsCSV["HealthRegen"])
	
	# get StartWeaponArray
	for Stringer in BaseStatsCSV["StartWeapons"].split(",", false):
		StartWeapons.append(str(Stringer).strip_edges())
	
#	Experience = BaseStatsCSV[_CharacterName]["Experience"]
	InitGrowthData()
	pass

func GetMaxHealth() -> float:
	return AMaxHealth + AddMaxHealth
	pass

func GetDamageMultiplier() -> float:
	return ADamageMultiplier + AddDamageMultiplier
	pass

func  GetMovementSpeed() -> float:
	return AMovementSpeed + AddMovementSpeed
	pass

func  GetProjectileAmount() -> int:
	return AProjectileAmount + AddProjectileAmount
	pass

func  GetAreaMultiplier() -> float:
	return AAreaMultiplier + AddAreaMultiplier
	pass

func  GetCooldownMultiplier() -> float:
	return ACooldownMultiplier + AddCooldownMultiplier
	pass

func  GetExperienceMultiplier() -> float:
	return AExperienceMultiplier + AddExperienceMultiplier
	pass

func GetHealthRegen() -> float:
	return HealthRegen + AddHealthRegen
	pass

func GetProjectileSpeed() -> float:
	return ProjectileSpeed + AddProjectileSpeed
	pass
	
func GetKnockbackAmount() -> float:
	return KnockBack + AddKnockBack
	pass

func LevelUp():
	AMaxHealth += GetArrayValue(MaxHealthGrowth, PlayerLevel -1)
	AMovementSpeed += GetArrayValue(MovementSpeedGrowth, PlayerLevel -1)
	ADamageMultiplier += GetArrayValue(DamageMultiplierGrowth, PlayerLevel -1)
	AProjectileAmount += GetArrayValue(ProjectileAmountGrowth, PlayerLevel -1)
	AAreaMultiplier += GetArrayValue(AreaMultiplierGrowth, PlayerLevel -1)
	ACooldownMultiplier += GetArrayValue(CooldownMultiplierGrowth, PlayerLevel -1)
	AExperienceMultiplier += GetArrayValue(ExperienceMultiplierGrowth, PlayerLevel -1)
	PlayerLevel += 1
	pass

func InitGrowthData():
	for StringElements in str(BaseStatsCSV["HealthGrowth"]).split(",", false):
			MaxHealthGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["DamageMultiplierGrowth"]).split(",", false):
			DamageMultiplierGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["MovementSpeedGrowth"]).split(",", false):
			MovementSpeedGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["ProjectileAmountGrowth"]).split(",", false):
			ProjectileAmountGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["AreaMultiplierGrowth"]).split(",", false):
			AreaMultiplierGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["CooldownMultiplierGrowth"]).split(",", false):
			CooldownMultiplierGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["ExperienceMultiplierGrowth"]).split(",", false):
		CooldownMultiplierGrowth.append(float(StringElements))

	for StringElements in str(BaseStatsCSV["HealthRegenGrowth"]).split(",", false):
		HealthRegenGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["ProjectileSpeedGrowth"]).split(",", false):
		ProjectileSpeedGrowth.append(float(StringElements))
	
	for StringElements in str(BaseStatsCSV["KnockbackGrowth"]).split(",", false):
		KnockBackGrowth.append(float(StringElements))

func GetArrayValue(ArrayItem, Index):
	if ArrayItem.size() == 0 or Index >= ArrayItem.size():
		return 0
	return ArrayItem[Index]
	pass
