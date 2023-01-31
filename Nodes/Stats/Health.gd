extends Node

#var CurHealth : float = 0
#var MaxHealth : float = 100
var isInvurnable = false

signal OnDeath()
signal OnTakeDamage(instigator, Damage)
signal OnAddHealth(Health)

var RegenTimer = Timer.new()
var HealthRegenTick = 0.4
var hasRegen = false

func SetHasRegen(_hasRegen):
	match _hasRegen:
		true:
			RegenTimer.start(HealthRegenTick)
			hasRegen = true
		false:
			RegenTimer.stop()
			hasRegen = false
	pass

func _ready():
	set_process(false)
	add_child(RegenTimer)
	RegenTimer.connect("timeout", self, "OnHealthRegenTick")
	SetHasRegen(true)
	pass

#func AssignStats(Stats):
#	MaxHealth = Stats.Health
#	pass

func ResetHealth():
	owner.CurStats.CurHealth = owner.CurStats.GetMaxHealth()
#	CurHealth = MaxHealth
	pass 

func TakeDamage(instigator : Object, Damage : float):
	if isInvurnable == true or Damage == 0:
		return
	owner.CurStats.CurHealth -= Damage
	#CurHealth = max(0 ,CurHealth)
	#print("You got hit by %s, you lose %d, your health is %s" %[instigator.name, Damage, CurHealth])
	emit_signal("OnTakeDamage", instigator, Damage)
	
	if owner.CurStats.CurHealth <= 0:
#		print("%s is dead" %owner.name)
		emit_signal("OnDeath")
		pass
	pass

func AddHealth(HealAmount : float):
	if owner.CurStats.CurHealth <= owner.CurStats.AMaxHealth:
		owner.CurStats.CurHealth += HealAmount
		owner.CurStats.CurHealth = min(owner.CurStats.CurHealth, owner.CurStats.AMaxHealth)
	#CurHealth = min(CurHealth, MaxHealth)
	emit_signal("OnAddHealth", HealAmount)
	pass

func OnHealthRegenTick():
	AddHealth(owner.CurStats.GetHealthRegen())
	pass
