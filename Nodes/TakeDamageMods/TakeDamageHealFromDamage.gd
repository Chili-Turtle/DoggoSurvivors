extends TakeDamageBaseMod
class_name TakeDamageHealFromDamage

func OnTakeDamage(_instigator, _damage):
	_instigator.get_node("Stats/Health").AddHealth(_damage/1.0)
	
