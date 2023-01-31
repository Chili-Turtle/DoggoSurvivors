extends Node2D

var ScriptPath

# check for same state, if has same state, reset timer
func AddState(_StateName : Object):
	
	for child in get_children():
		if child.is_stackable == false:
#		if child.get("StateName"): # TIP to ask if a node has a variable/property use get("VarName")
			if child.StateName == _StateName.StateName:
				child.ResetTime() # TODO call it more like reactivate state, not every state has a is timer based
				return
#
#	var NewInst = load("res://Nodes/State/State.tscn").instance()
#	AssignBaseStats(_StateName)
#	var AttachedScript = ScriptPath
#	NewInst.set_script(AttachedScript)
#	add_child(NewInst)
#	NewInst.InitStateValues(_StateName)
#	NewInst.StateName = _StateName
#	NewInst.owner = owner
	add_child(_StateName)
	_StateName.owner = owner


## helper functions
func AssignBaseStats(_StateName : String): # should that be in the stats container?
		if _StateName.empty():
			return
		var BaseStats : Dictionary = GameFunction.readCSV(DataPath.GetStateData())
		ScriptPath = SaveLoadResource(BaseStats[_StateName]["ScriptPath"])

# load resource from csvdata string
func SaveLoadResource(ResourceString : String):
	if ResourceString == "none" or ResourceString.empty():
		return null
	
	return load(ResourceString)
	pass
