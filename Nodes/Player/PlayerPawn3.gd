extends KinematicBody2D

onready var Collision_Shape = $CollisionShape2D
onready var Healthbar = get_node("%Healthbar")

var CurStats : Resource = PlayerStats.new()

# featch Components
onready var NavObstacle = $NavigationObstacle2D # HACK cur bug fix
onready var PlayerCamera = $Camera2D
onready var Health = $Stats/Health
onready var Experience = $Stats/Experience
onready var PlayerAnimatedSprite = $AnimatedSprite

# UI
var PlayerGUI = preload("res://Nodes/Widget/GUI.tscn") # the packed scene
var GameOverScreen = preload("res://Nodes/Widget/GameOverScreen.tscn") # the packed scene
var playerGUI # saved instance


# Player Properties
var velocity : Vector2
var direction : Vector2
var LastDirection : Vector2 = Vector2(1,0)
#var WeaponDirection : Vector2 = Vector2(1,0) # HACK DO I still need this (I gues was just there for the lerping weapon pos experiment)
#var timer : float # HACK Same here just the lerp experiment
export (GameFunction.E8WayDir) var PlayerMoveDir #export so I can have a type
var ColorTween : Tween
var BloodParicles = preload("res://ParticlesSytems/BloodParicles.tscn")
var BloodInstance
#var InitWeapons : Array = ["Knife"]

### new Propertyies
enum EMovementState{Walk, Charge}
var MovementState = EMovementState.Walk
var DirectionChangeAmount : float
var MaxSpeedAccumulation : float = 0.0

func LevelUp():
	CurStats.LevelUp()
	pass

func ModStats():
	# reset values
	CurStats.AddDamageMultiplier = 0
	CurStats.AddMaxHealth = 0
	CurStats.AddMovementSpeed  = 0
	CurStats.AddProjectileAmount = 0
	CurStats.AddAreaMultiplier = 0
	CurStats.AddCooldownMultiplier = 0
	CurStats.AddExperienceMultiplier = 0
	CurStats.AddHealthRegen = 0
	CurStats.AddProjectileSpeed = 0
	CurStats.AddKnockBack = 0
	
	for child in $States.get_children():
		if child.is_Active == false:
			continue
		CurStats.AddDamageMultiplier += child.Stats.ADamageMultiplier
		CurStats.AddMaxHealth += child.Stats.AMaxHealth
		CurStats.AddMovementSpeed  += child.Stats.AMovementSpeed
		CurStats.AddProjectileAmount += child.Stats.AProjectileAmount
		CurStats.AddAreaMultiplier += child.Stats.AAreaMultiplier
		CurStats.AddCooldownMultiplier += child.Stats.ACooldownMultiplier
		CurStats.AddExperienceMultiplier += child.Stats.AExperienceMultiplier
		CurStats.AddHealthRegen += child.Stats.HealthRegen
		CurStats.AddProjectileSpeed += child.Stats.ProjectileSpeed
		CurStats.AddKnockBack += child.Stats.KnockBack
	pass

func AddStates(CharacterName): #Adds the Init De/Buffs
#	var CSVDATA = GameFunction.readCSV(DataPath.GetPlayerData())
	var CSVDATA
	for character in GameFunction.readJson("res://CSVData/CharacterBaseStats.json"):
		if character.id == CharacterName:
			CSVDATA = character
			pass
#	if str(CSVDATA[CharacterName]["Buffs/De"]) != "":
	if str(CSVDATA["Buffs/De"]) != "":
		var ScriptPacked = load(CSVDATA["Buffs/De"])
		var BuffNode = Node.new()
		BuffNode.set_script(ScriptPacked)
		get_node("States").add_child(BuffNode)
		BuffNode.owner = self
	pass

func AddWeapon(WeaponName : String):
#	return #Debug 
#	var CSVDATA = GameFunction.readCSV(DataPath.GetItemData())
	var CSVDATA
	for weapon in GameFunction.readJson('res://CSVData/WeaponData.json'):
		if weapon.id == WeaponName:
			CSVDATA = weapon

	var Weapon = GameFunction.SpawnActor(load(CSVDATA["ItemPath"]), Vector2(), 0.0, Vector2(1, 1), get_node("WeaponHolster"), self)
	Weapon.Instigator = self
	Weapon.CurStats.AssignBaseStats(WeaponName)
	playerGUI.AddItemToCoolDownPanel(WeaponName, Weapon.CurStats.SpriteResource.get_frame("default", 0), Weapon.WeaponCoolDownTimer)
#	var Weapon = load(CSVDATA[WeaponName]["ItemPath"]).instance()
#	add_child(Weapon)
#	get_node("WeaponHolster").add_child(Weapon)
	pass

func KnockBack(Instigator, KnockbackAmount : float): #TODO Make this a extra state/node
	print(KnockbackAmount)
	if KnockbackAmount == 0:
		return
	
	var KnockBackDir : Vector2
	if is_instance_valid(Instigator):
		KnockBackDir = Instigator.position - self.position
	
	KnockBackDir = KnockBackDir.normalized() * KnockbackAmount / 2
	direction = KnockBackDir

func CreateCharacterStats(CharacterName):
	CurStats.AssignBaseStats(CharacterName)
	AddStates(CharacterName)
	pass

func OnPosses():
	PlayerManager.set_PlayerPawn(self)
	pass

func _init():
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	_ready()
	pass

func _ready():
	OnPosses()
	CreateCharacterStats(PlayerManager.SelectedPlayerName)
	
	
	
	BloodInstance = BloodParicles.instance()
	self.add_child(BloodInstance)
	
	ColorTween = Tween.new() #tween for player damage color
	add_child(ColorTween)
	
	Experience.connect("OnLevelUp", self, "LevelUp")
	
	# FIXME temp fix for godot 3.5.0
	Navigation2DServer.agent_set_map(NavObstacle.get_rid(), get_world_2d().navigation_map)
	
	playerGUI = PlayerGUI.instance()
	UiManager.AddUI(playerGUI)
	
	playerGUI.OnUpdateExperienceBar(Experience.CurExperience / Experience.NextLvLExperience, Experience.PlayerLevel)
	
	playerGUI.InitLevelProgress(LevelManager.WaveData)
	
	Health.ResetHealth()
	Health.connect("OnTakeDamage", self, "OnTakeDamage")
	Health.connect("OnAddHealth" ,self, "OnAddHealth")
	Health.connect("OnDeath", self, "OnDeath")
	
	Experience.connect("OnAddExperience", self, "OnAddExperience")
	
	Healthbar.value = (CurStats.CurHealth / CurStats.GetMaxHealth()) * 100
	
	for child in $WeaponHolster.get_children(): # DEPRICATED delete this
		if child.get("CurStats"):
			if child.CurStats != null:
				if child.CurStats.get("ItemName") != null: #check if Item has WeaponName property
					print(child.CurStats.ItemName)
	
	for WeaponName in CurStats.StartWeapons: # has to be done like that, otherwise if AddWeapon is Called and the PlayerPawn is not ready, the Weapon position is completelly
		AddWeapon(WeaponName)
	pass

func OnTakeDamage(instigator, Damage):
	# set color of player
	ColorTween.interpolate_property(PlayerAnimatedSprite, "self_modulate", Color.red, Color.white, 0.2, Tween.TRANS_SINE, Tween.EASE_IN, 0.0)
	ColorTween.start()
	
	if !BloodInstance.is_emitting():
		BloodInstance.restart()

	BloodInstance.emitting = true
	Healthbar.value = (CurStats.CurHealth / CurStats.GetMaxHealth()) * 100
	pass

func OnAddHealth(Health):
	Healthbar.value = (CurStats.CurHealth / CurStats.GetMaxHealth()) * 100
	pass

func OnDeath():
	hide()
	
	UiManager.AddUI(GameOverScreen.instance(), true)
	Collision_Shape.disabled = true
	set_process(false)
#	direction = Vector2()
	velocity = Vector2()
	print("you are dead")
	for children in $WeaponHolster.get_children():
		if is_instance_valid(children):
			children.queue_free()
	pass

func OnAddExperience():
	playerGUI.OnUpdateExperienceBar(Experience.CurExperience / Experience.NextLvLExperience, Experience.PlayerLevel)
	pass

func GetAllWeapons():
	var WeaponsArray : Array
	for child in $WeaponHolster.get_children():
		if child.CurStats != null:
			if child.CurStats.get("ItemName") != null: #check if Item has WeaponName property
				WeaponsArray.append(child)
	return WeaponsArray
	pass

func GetWeapon(WeaponName : String): # TODO save your weapons to an array when adding them (no looping threw children/ Checking the property of weapons all the time)
	for child in $WeaponHolster.get_children():
		if child.CurStats != null:
			if child.CurStats.get("ItemName") != null: #check if Item has WeaponName property
				if child.CurStats.ItemName == WeaponName:
					return child

func HasWeapon(_WeaponName : String) -> bool: # TODO save your weapons to an array when adding them (no looping threw children/ Checking the property of weapons all the time)
	for child in $WeaponHolster.get_children():
		if child.CurStats != null:
			if child.CurStats.get("ItemName") == _WeaponName: #check if Item has WeaponName property
				return true

	return false

	pass

func _process(delta):
	ModStats()
	update()
	
	playerGUI.UpdateValues(CurStats)
	playerGUI.UpdatewaveProgress()
	
	for child in $WeaponHolster.get_children():
		if child.CurStats != null:
			if child.CurStats.get("ItemName") != null: #check if Item has WeaponName property
				playerGUI.UpdateCooldown(child.CurStats.GetCooldown(), child.WeaponCoolDownTimer, child.CurStats.ItemName)
#				printerr("cd: %.2f %.2f" %[child.WeaponCoolDownTimer, child.CurStats.GetCooldown()])
	
	var XAxis = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	var YAxis = Input.get_action_strength("MoveDown") - Input.get_action_strength("MoveUp")
	
	Get8WayDirection(Vector2(XAxis, YAxis))
	#WeaponDirection = Vector2(1, 1)
	
	if XAxis > 0:
		get_node("AnimatedSprite").flip_h = false
	elif XAxis < 0:
		get_node("AnimatedSprite").flip_h = true
		pass
		
	direction = Vector2(XAxis, YAxis)
	direction = direction.normalized()
	
	# ---- steering the right steering
	#var max_speed = 45
#	var max_force = 0.01
	var max_force =0.02 #* AccelerationCurve.interpolate(velocity.length() / CurStats.GetMovementSpeed())
	var MaxChargeTank = 2.0
	var MaxDirectionChangeAmount = 0.7
	
	var disired_velocity =  direction * CurStats.AMovementSpeed # used to be direction (target - position).normalized()
	var NormlaizedDirectionChangeAmount = ((direction.normalized().dot(velocity.normalized()) + 1.0) * 0.5 )
	DirectionChangeAmount = direction.normalized().dot(velocity.normalized())
	var steer = Vector2() #disired_velocity - velocity
	var target_velocity = Vector2() #velocity + (steer * max_force)
	
	match MovementState:
		EMovementState.Walk:
			steer = disired_velocity - velocity

			if velocity.length() >= CurStats.AMovementSpeed - 2.0: # DirectionChangeAmount >= MaxDirectionChangeAmount and :
				MaxSpeedAccumulation += delta
				MaxSpeedAccumulation = min(MaxSpeedAccumulation, MaxChargeTank)
			
			if MaxSpeedAccumulation >= MaxChargeTank:
				MovementState = EMovementState.Charge
				pass
			
			target_velocity = velocity + (steer * max_force)
			pass
		EMovementState.Charge:
			max_force = 0.01
			
			# subtact steering accumulation / aad steering accumulation
			if DirectionChangeAmount <= MaxDirectionChangeAmount:
				MaxSpeedAccumulation -= delta
				MaxSpeedAccumulation = max(0.0, MaxSpeedAccumulation)
			else:
				MaxSpeedAccumulation += delta*0.2
				MaxSpeedAccumulation = min(MaxSpeedAccumulation, MaxChargeTank)
			
			steer = disired_velocity - velocity
			# strafing
#			if DirectionChangeAmount >= 0.0:
#				steer = disired_velocity - velocity
#			else:
#				steer = Vector2()
			
			if MaxSpeedAccumulation <= 0.0:
				MovementState = EMovementState.Walk
				pass

			 # check for Input "direction" and "steer" has the same direction
			if direction.normalized().dot(steer.normalized()) > 0.9  : #when bought have to same direction normaly nothing happeds(strafing behaviour), so I nude the steer a tit bit over
				steer = direction.rotated(deg2rad(10)) * CurStats.GetMovementSpeed()
			
			target_velocity = velocity + (steer * max_force)
			target_velocity = target_velocity.normalized() * CurStats.AMovementSpeed
			pass
		_:
			printerr("Something went wrong pls check your brain Idiot ")
			pass
			
	velocity = target_velocity

	if velocity.length() > 0:
		get_node("AnimatedSprite").animation = "run"
	else:
		get_node("AnimatedSprite").animation = "idle"
		pass
	pass
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2(), false)
	pass

func _input(event):
	#print(MoveDir.keys()[PlayerMoveDir])
	
	if event.is_action_pressed("ui_cancel"):
#		get_tree().paused = !get_tree().paused
		var pause =  preload("res://Nodes/Widget/PauseMenu.tscn").instance()
		UiManager.AddUI(pause)
#		get_tree().quit()
		pass
	if event.is_action_pressed("MouseWheelUp"):
#		if PlayerCamera.zoom.x >= 0.1:
#			PlayerCamera.zoom -= Vector2(0.01, 0.01)
			pass
	if event.is_action_pressed("MouseWheelDown"):
#		if PlayerCamera.zoom.x < 0.5:
#			PlayerCamera.zoom += Vector2(0.01, 0.01)
#			pass
		pass
	pass

func Get8WayDirection(InputDirection):
	if InputDirection.length() != 0:
		var WalkDirectionDeg = rad2deg(InputDirection.angle())
		
		if WalkDirectionDeg > -22.5 and WalkDirectionDeg < 22.5:
			PlayerMoveDir = GameFunction.E8WayDir.Right
		elif WalkDirectionDeg > -67.5 and WalkDirectionDeg < -22.5:
			PlayerMoveDir = GameFunction.E8WayDir.DiagonalUp_Right
		elif WalkDirectionDeg > -112.5 and WalkDirectionDeg < -67.5:
			PlayerMoveDir = GameFunction.E8WayDir.Up
		elif WalkDirectionDeg > -157.5 and WalkDirectionDeg < -112.5:
			PlayerMoveDir = GameFunction.E8WayDir.DiagonalUp_Left
		elif WalkDirectionDeg > -202.5 and WalkDirectionDeg < -157.5 or WalkDirectionDeg < 202.5 and WalkDirectionDeg > 157.5:
			PlayerMoveDir = GameFunction.E8WayDir.Left
		elif WalkDirectionDeg < 157.5 and WalkDirectionDeg > 112.5:
			PlayerMoveDir = GameFunction.E8WayDir.DiagonalDown_Left
		elif WalkDirectionDeg < 112.5 and WalkDirectionDeg > 67.5:
			PlayerMoveDir = GameFunction.E8WayDir.Down
		elif WalkDirectionDeg < 67.5 and WalkDirectionDeg > 22.5:
			PlayerMoveDir = GameFunction.E8WayDir.DiagonalDown_Right
			pass

func _draw():
	#draw velocity
	if DirectionChangeAmount >= 0.7:
		draw_line(Vector2(), velocity, Color.blue, 2)
	else:
		draw_line(Vector2(), velocity, Color.red, 2)
	
	# draw direction
	draw_line(Vector2(), direction.normalized() * 20, Color.green, 1)
	
	# draw arcs, strafe zone
	draw_arc(Vector2(), 20, deg2rad(90) + velocity.angle(), deg2rad(-90) + velocity.angle(), 5, Color.green, 2.0)
	# arc turn malus amount
	draw_arc(Vector2(), 22, 0.7 + velocity.angle(), -0.7 + velocity.angle(), 5, Color.red, 2.0) #0.79 == ~45 deg
	
	# max speed point
	if MaxSpeedAccumulation >= 2.0 or MovementState == EMovementState.Charge:
		draw_circle(velocity, 2, Color.red)
	else:
		draw_circle(velocity, 2, Color.green)
		pass
	pass
