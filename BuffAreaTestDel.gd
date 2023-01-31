extends Area2D

var BuffNode : Node2D
var scriptKid = preload("res://Nodes/State/ExtraDamageAreaBuff.gd")
#var ssfa = preload("res://Nodes/State/ExtraDamageAreaBuff.gd")

enum EChargeStates {Emptied, Charged}

var is_charged = true
var is_active = false
var chargeValue = 100

var ChargeState = EChargeStates.Charged

var curBody = null

func _ready():
	$ChargeValueProgress.value = chargeValue
	$"../Timer".connect("timeout", self, "OnTimeOut")
	$"../Timer".start(1)
	
	BuffNode = Node2D.new()
	BuffNode.set_script(scriptKid)
	BuffNode.InitStateValues('WellBuff')
	pass

# add buff node when entering area
func _on_BuffAreaTest_body_entered(body):
	if body == PlayerManager.PlayerPawn and chargeValue > 0:
		# Playerbody = body
		curBody = body
		body.get_node("States").add_child(BuffNode)
#		BuffNode.owner = body
	pass

# remove buff node when entering area
func _on_BuffAreaTest_body_exited(body):
	if body == PlayerManager.PlayerPawn:
		curBody = null
		ChargeState = EChargeStates.Emptied
		body.get_node("States").remove_child(BuffNode)
	pass

func OnTimeOut(): #TODO If I Inside the fountain and my health reaches 100%, the foutain charge doesn't recharge, fix If Player Has full hp and charge is not at 100% recharge
	
	$ChargeValueProgress.value = chargeValue
	
	match ChargeState:
# healign
		EChargeStates.Charged:
			
			#if player is in area subtract
			if curBody != null and curBody.CurStats.CurHealth < curBody.CurStats.AMaxHealth:
				chargeValue -= 20
				chargeValue = max(chargeValue, 0)

			# change state to charging
			if chargeValue <= 0:
				ChargeState = EChargeStates.Emptied
				PlayerManager.PlayerPawn.get_node("States").remove_child(BuffNode)
# charging
		EChargeStates.Emptied:
			chargeValue += 1
			chargeValue = min(chargeValue, 100)
			
			# fully charged
			if chargeValue >= 100:
				ChargeState = EChargeStates.Charged
				# if player still in area add buff
				if curBody != null:
					curBody.get_node("States").add_child(BuffNode)
			pass
	
	
	# add chargeValue if under 0 turn of is charged
#
#		if is_charged == true: #remove child if charge is still true
#			PlayerManager.PlayerPawn.get_node("States").remove_child(BuffNode)
#
#		is_charged = false
#
#	if chargeValue >= 100:
#		is_charged = true
	
	pass

func _draw():
	draw_arc(Vector2(), 100, 0, PI*2, 32, Color(1.0, 1.0, 0.0, 0.4), 1.5, true)
#	draw_circle(Vector2(), 100, Color(Color.greenyellow.r, Color.greenyellow.g, Color.greenyellow.b, 0.4))
