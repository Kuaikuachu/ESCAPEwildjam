extends AudioStreamPlayer3D

@export var play_sound : bool = false

func _physics_process(_delta):
	if play_sound:
		play_sound = false
		self.play(0.0)
