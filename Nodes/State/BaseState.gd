extends Node

# Do I need the State Node? I could make a new node2 then assign the script to it

onready var StateTimer = Timer.new()# $"%StateTimer"
onready var StateIntervalTimer = Timer.new() #$"%StateIntervalTimer"

var StateName = "Dick"

var BuffOwner = null

var Stats = PlayerStats.new()

var Level = 1

var StateTime = 2.0
var StateInterval = 0.5

var CSVDATA = null

var is_stackable = false

var is_Active = true
var type = "Buff" # DamageBuff, PassiveAbility

var StateCounter = 0

func ResetTime():
	StateTimer.start(StateTime)
	pass

func InitStateValues(_StateName): #_BuffOwner
#	BuffOwner = _BuffOwner
	StateName = _StateName
#	CSVDATA = GameFunction.readCSV(DataPath.GetStateData())
	for states in GameFunction.readJson('res://CSVData/States.json'):
		if states.id == _StateName:
			CSVDATA = states
			pass
	printerr(_StateName)
	# if De/Buff has an entry
	if CSVDATA.has(_StateName):
		Stats.AAreaMultiplier = float(CSVDATA[_StateName]["AareaMultiplier"])
		Stats.ACooldownMultiplier = float(CSVDATA[_StateName]["AcooldownMultiplier"])
		Stats.ADamageMultiplier = float(CSVDATA[_StateName]["AdamageMultiplier"])
		Stats.AExperienceMultiplier = float(CSVDATA[_StateName]["AexperienceMultiplier"])
		Stats.AMaxHealth = float(CSVDATA[_StateName]["AmaxHealth"])
		Stats.AMovementSpeed = float(CSVDATA[_StateName]["AmovementSpeed"])
		Stats.AProjectileAmount = float(CSVDATA[_StateName]["AprojectileAmount"])
		Stats.HealthRegen = float(CSVDATA[_StateName]["HealthRegen"])
		is_stackable = bool(int(CSVDATA[_StateName]["Stackable"]))
		
		printerr("this is stacks {0}".format({'0' : (int(CSVDATA[_StateName]["Stackable"]))}))
	pass

func LevelUp():
	printerr(StateName)
	if CSVDATA.has(StateName):
		Stats.AAreaMultiplier += float(CSVDATA[StateName]["AareaMultiplierGrowth"])
		Stats.ACooldownMultiplier += float(CSVDATA[StateName]["AcooldownMultiplierGrowth"])
		Stats.ADamageMultiplier += float(CSVDATA[StateName]["AdamageMultiplierGrowth"])
		Stats.AExperienceMultiplier += float(CSVDATA[StateName]["AexperienceMultiplierGrowth"])
		Stats.AMaxHealth += float(CSVDATA[StateName]["AmaxHealthGrowth"])
		Stats.AMovementSpeed += float(CSVDATA[StateName]["AmovementSpeedGrowth"])
		Stats.AProjectileAmount += int(CSVDATA[StateName]["AprojectileAmountGrowth"])
		
		Level += 1
	pass

func _ready():
	add_child(StateTimer)
	StateTimer.connect("timeout", self, "OnTimeOut")
	
#	var CSVDATA = GameFunctiwon.readCSV(DataPath.GetStateData())
	var CSVDATA
	for state in GameFunction.readJson('res://CSVData/States.json'):
		if state.id == StateName:
			CSVDATA = state
#	if CSVDATA.has(StateName):
#		print(CSVDATA[StateName])
#		pass
		
	add_child(StateIntervalTimer)
	StateIntervalTimer.connect("timeout", self, "OnIntervalTimeout")
	
	StateTimer.start(StateTime)
	StateIntervalTimer.start(StateInterval)
	pass

# Play Particles
# If already state exist reset timer
# Should I just have a timer for State parent, and go threw all States?

func OnTimeOut():
	queue_free()
	pass

func OnIntervalTimeout():
	pass

func ActivateState():
	# Do StateStuff
#	StateCounter += 1
#	if StateCounter > 10:
#		queue_free()
#		pass
	pass
