extends Area2D

var PlantTimer = 0.0
var NextFrameTime = 2.0
var doneSound = load("res://Sounds/sfx/Coins/pick up Coin 3.wav")
signal OnCollected(Instigator)


func _ready():
	$AudioStreamPlayer.stream_paused = true
	pass


func _process(delta):
	
	if $Sprite.frame >= 5:
		SoundManager.PlaySound_simple(doneSound)
		emit_signal("OnCollected", self)
		DeSpawn()
		return
		pass
	
	if get_overlapping_bodies().size() > 0:
		for body in get_overlapping_bodies():
			if body == PlayerManager.PlayerPawn:
				PlantTimer += delta
				$AudioStreamPlayer.stream_paused = false
	#			if $AudioStreamPlayer.playing == false:
	#				$AudioStreamPlayer.play()
				if PlantTimer >= NextFrameTime:
					PlantTimer = 0.0
					$Sprite.frame += 1
					EnemySpawner.SpawnEnemieCircel("Goblin", 4) #TODO Change this so I call it with the csv data (just the name of the enemy)
	else:
		$AudioStreamPlayer.stream_paused = true
		pass

#	if get_overlapping_bodies().size() <= 0:
#		PlantTimer -= delta
#		if PlantTimer <= NextFrameTime:
#					PlantTimer = 0.0
#					$Sprite.frame -= 1
	pass


func DeSpawn():
	queue_free()
	pass

func _on_Onion_body_exited(body):
	if body == PlayerManager.PlayerPawn:
		$AudioStreamPlayer.stream_paused = true
	pass # Replace with function body.
