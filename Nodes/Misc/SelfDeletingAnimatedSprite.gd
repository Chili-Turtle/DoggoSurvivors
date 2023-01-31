extends AnimatedSprite

func SpawnAnSpriteEffect(_position : Vector2, FramesResource : SpriteFrames):
#	get_tree().root.get_viewport().add_child(SpriteOneShot)
	self.position = _position
	self.frames = FramesResource
	self.animation = "Idle"
	self.frame = 0
#	self.loop = false
	self.playing = true
	self.connect("animation_finished", self, "OnAnimationFinished")

func OnAnimationFinished():
	queue_free()
	pass
