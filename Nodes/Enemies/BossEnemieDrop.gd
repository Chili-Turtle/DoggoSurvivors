class_name BossEnemieDrop

extends Drops

var Chest = preload("res://Nodes/Gems/Chest.tscn")

var WeightsArray = [1] #luck infuenze [1, 1.2, 1.5]
var ItemArray = [Chest]

var DropChance = 25 # in %
var MaxDropAmount = 1
var CurDropAmount = 0

func _ready():
	randomize()
	pass

func RollDrop(_owner):
	# calc the Sum/100% of the Weight for the RandomRange
	var SumWeight = 0
	for Weight in WeightsArray:
		SumWeight += Weight
	
	var RandWeight = rand_range(0, SumWeight)
	var CurWeight = 0.0
	
	if DropChance > rand_range(0, 100): #drop change
		for i in range(0, WeightsArray.size()): #check all items in pool
			CurWeight += WeightsArray[i]
			if RandWeight <= CurWeight: # if in RandWeight is in WeightRange
				var ItemToSpawn = ItemArray[i].instance()
				ItemToSpawn.position = _owner.position + Vector2(rand_range(-20, 20), rand_range(-20, 20))
				_owner.get_parent().add_child(ItemToSpawn) # TODO make a level manager and have the ySort as reference
				break

		if CurDropAmount < MaxDropAmount - 1: # if succesfull drop get a nother
			DropChance *= 0.4 + (abs(1.0 - 1.5) * 0.1 ) # so it does not drop from 60 to 30 abs(1- luck) * luck factor
			CurDropAmount += 1
			RollDrop(_owner)
			pass
	pass
