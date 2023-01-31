class_name AirTimeEndRemoveProjectile
extends AirTimeEnd

func AirTimeEnd(_Instigator, _positoin):
	if is_instance_valid(_Instigator.get_parent()): # is_inside_tree()
		_Instigator.get_parent().remove_child(_Instigator)
	pass
