extends Panel

func _ready():
	pass

func UpdateValues(_PlayerStats):
	$"%PlayerStatsSlotHealth".get_node("StatName").text = "Max Health"
	$"%PlayerStatsSlotHealth".get_node("Base").text = "%d" %_PlayerStats.AMaxHealth
	$"%PlayerStatsSlotHealth".get_node("Additional").text = "%d" %_PlayerStats.AddMaxHealth
	
	$"%PlayerStatsSlotDamage".get_node("StatName").text = "Damage"
	$"%PlayerStatsSlotDamage".get_node("Base").text = "%.2f" %_PlayerStats.ADamageMultiplier
	$"%PlayerStatsSlotDamage".get_node("Additional").text = "%.2f" %_PlayerStats.AddDamageMultiplier
	
	$"%PlayerStatsSlotMovementSpeed"
	$"%PlayerStatsSlotMovementSpeed".get_node("StatName").text = "Movement Speed"
	$"%PlayerStatsSlotMovementSpeed".get_node("Base").text = "%.2f" %_PlayerStats.AMovementSpeed
	$"%PlayerStatsSlotMovementSpeed".get_node("Additional").text = "%.2f" %_PlayerStats.AddMovementSpeed
	
	$"%PlayerStatsSlotProjectileAmount"
	$"%PlayerStatsSlotProjectileAmount".get_node("StatName").text = "ProjectileAmount"
	$"%PlayerStatsSlotProjectileAmount".get_node("Base").text = "%d" %_PlayerStats.AProjectileAmount
	$"%PlayerStatsSlotProjectileAmount".get_node("Additional").text = "%d" %_PlayerStats.AddProjectileAmount
	
	$"%PlayerStatsSlotHealthRegen"
	$"%PlayerStatsSlotHealthRegen".get_node("StatName").text = "Health Regen"
	$"%PlayerStatsSlotHealthRegen".get_node("Base").text = "%.2f" %_PlayerStats.HealthRegen
	$"%PlayerStatsSlotHealthRegen".get_node("Additional").text = "%.2f" %_PlayerStats.AddHealthRegen
	
	$"%PlayerStatsSlotProjectileSpeed"
	$"%PlayerStatsSlotProjectileSpeed".get_node("StatName").text = "Projectile Speed"
	$"%PlayerStatsSlotProjectileSpeed".get_node("Base").text = "%.2f" %_PlayerStats.ProjectileSpeed
	$"%PlayerStatsSlotProjectileSpeed".get_node("Additional").text = "%.2f" %_PlayerStats.AddProjectileSpeed
	
	# #GetMovementSpeed GetProjectileAmount
	
	
	
	
	
	
	
	
	pass
