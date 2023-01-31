extends Node

var SFXPlayersP : Array
var SFXPlayers : Array# 2 deminsional Array exp: [["Player1", Priority], ["Player2", Priority]]
var ComboArray : Array # 2 deminsional Array exp: [[["ComboName", ComboPitch, LastComboTime]], ["Gem", 1.5, time in msec]]

var ComboAmount : int = 0
var PitchStepSize = 0.005

var LastAudio : AudioStream
var ComboTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	SFXPlayers.append([AudioStreamPlayer.new(), -1])
	add_child(SFXPlayers.back()[0])
	SFXPlayers.back()[0].set_bus("SFX")
	
	SFXPlayers.append([AudioStreamPlayer.new(), -1])
	add_child(SFXPlayers.back()[0])
	SFXPlayers.back()[0].set_bus("SFX")
	
	SFXPlayers.append([AudioStreamPlayer.new(), -1])
	add_child(SFXPlayers.back()[0])
	SFXPlayers.back()[0].set_bus("SFX")
	
#	------------------
	SFXPlayersP.append(AudioStreamPlayer.new())
	add_child(SFXPlayersP.back())
	SFXPlayersP.back().set_bus("SFX")
	
	SFXPlayersP.append(AudioStreamPlayer.new())
	add_child(SFXPlayersP.back())
	SFXPlayersP.back().set_bus("SFX")
	
	SFXPlayersP.append(AudioStreamPlayer.new())
	add_child(SFXPlayersP.back())
	SFXPlayersP.back().set_bus("SFX")
#	------------------
	
	ComboTimer = Timer.new()
	ComboTimer.connect("timeout", self, "OnResetComboCounter")
	add_child(ComboTimer)
	pass

func PlaySound_simple(AudioSource : AudioStream, Volume = 0.0, pitch = 1.0): # old and depricated
	if LastAudio != null:
		if LastAudio == AudioSource:
			ComboAmount += 1
			pass
		pass
	
	if ComboAmount * 0.01 >= 1.0:
		ComboAmount *= 0.25
		pass

	var LastPlayer = null
	for player in SFXPlayersP:
		if !player.playing:
			player.pitch_scale = pitch + min((ComboAmount * 0.01), 1)
			player.volume_db = Volume
			player.stream = AudioSource
			player.play()
			ComboTimer.start(0.25)
			LastAudio = AudioSource
			return

		if LastPlayer != null:
			if LastPlayer.get_playback_position() < player.get_playback_position():
				pass
		else:
			LastPlayer = player
			player.pitch_scale = pitch + min((ComboAmount * 0.05), 1)
			player.stream = AudioSource
			player.volume_db = Volume
			player.play()
			ComboTimer.start(0.25)
			LastAudio = AudioSource
	pass
	
func PlaySound(AudioSource : AudioStream, Volume = 0.0, pitch = 1.0, priority = -1, ComboName = ""):
	var PlayerToPlay: AudioStreamPlayer

# -------------------- select empty player --------------------
	for player in SFXPlayers: # select Audioplayer
		if IsPlayerEmpty(player[0]):
			player[1] = priority
			PlayerToPlay = player[0]
			break

# -------------------- select player with lowest priority -------------------- if all players are playing, check the priority
	if PlayerToPlay == null:
		var TempPlayer : Array
		for i in range(0, SFXPlayers.size()):
			if i == SFXPlayers.size() - 1:
				break

			if SFXPlayers[i][1] < SFXPlayers[i + 1][1]:
				SFXPlayers[i][1] = priority
				PlayerToPlay = SFXPlayers[i][0]

# -------------------- select player with hightest play time -------------------- if every one has the same priority go to next one
		if PlayerToPlay == null:
			PlayerToPlay = GetPlayerWithLongestPlayLength(SFXPlayers)[0][0] # get the first player in the array
			SFXPlayers[0][1] = priority
			pass

	PlayerToPlay.pitch_scale = pitch + GetComboPitch(ComboName)
	PlayerToPlay.volume_db = Volume
	PlayerToPlay.stream = AudioSource
	AudioServer.get_bus_effect(1, 1).pan = rand_range(-0.1, 0.1)
	PlayerToPlay.play()
	pass

func GetComboPitch(ComboName := "") -> float:
# deletes ComboElement, if the time difference is to high
	for Combo in ComboArray:
		if OS.get_system_time_msecs() - Combo[2] >= 1000: # in ms
			ComboArray.erase(Combo)
			pass

# if no ComboName return
	if ComboName == "":
		return 0.0

# if combo element was found add pitch and return it
	for Combo in ComboArray:
		if Combo.has(ComboName):
			Combo[2] = OS.get_system_time_msecs()
			Combo[1] += PitchStepSize
			if Combo[1] > 1.5: # resets the Combo pitch to the half
				Combo[1] *= 0.5
			return min(Combo[1], 1) # return max 1
			pass
	
# if no combo element was found, add one
	ComboArray.append([ComboName, 0, OS.get_system_time_msecs()])
	return 0.0
	pass

func OnResetComboCounter():
	ComboAmount = 0
	pass

func IsPlayerEmpty(player : AudioStreamPlayer):
	if !player.playing:
		return true
	else:
		return false

func GetPlayerWithLongestPlayLength(PlayerArray : Array): # [["Player1", Priority], ["Player2", Priority]]
	PlayerArray.sort_custom(SortAudioStreamPlayer, "sort_ascending_playback_position")
	return PlayerArray
	pass

class SortAudioStreamPlayer:
	static func sort_ascending_playback_position(a, b ):
		if a[0].get_playback_position() > b[0].get_playback_position():
			return true
		return false
