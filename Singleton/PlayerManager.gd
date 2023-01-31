extends Node


var PlayerPawn : KinematicBody2D
var SelectedPlayerName = ""

# var ItemPool = ["Banana", "Berd", "Jeff"] # HACK DO I EVEN NEED THIS

func set_PlayerPawn(_PlayerPawn):
	PlayerPawn = _PlayerPawn
	
	for child in get_all_children(_PlayerPawn):
		if child is Camera2D or child is Camera:
			CameraManager.set_camera(child)
	pass

func get_PlayerPawn():
	if is_instance_valid(PlayerPawn):
		return PlayerPawn
	pass

func IsPlayerPawnValid():
	if is_instance_valid(PlayerPawn):
		return true
	else:
		return false
	pass

# find all children of children
func get_all_children(NodeToCheck) -> Array:
	var ChildrenList : Array
	ChildrenList.push_back(NodeToCheck)
	for child in NodeToCheck.get_children():
		ChildrenList.append_array(get_all_children(child))
	return ChildrenList
