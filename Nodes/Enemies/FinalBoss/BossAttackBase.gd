extends Resource
class_name BossAttack

signal AttackFinished()

func StartAttack(_position, _Instigator):
	pass

func OnAttackFinished():
	printerr("AttackFinished in boss attack")
	emit_signal("AttackFinished")
	pass
