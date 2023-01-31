class_name WeaponAnimationFinishedRemoveProjectile
extends Resource

func WeaponAnimationFinished(_Instigator):
	if is_instance_valid(_Instigator.get_parent()): # is_inside_tree()
		_Instigator.get_parent().remove_child(_Instigator)
	pass
