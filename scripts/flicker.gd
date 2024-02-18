extends SpotLight3D

@onready var timer = $Timer

var flicker_max : float = 9.0
var flicker_min : float = 0.3
var flicker_idx : float = 0.0

func _physics_process(delta):
	if flicker_idx <= 0.0:
		light_energy = 0.1
		timer.start()
		flicker_idx = randf_range(flicker_min,flicker_max)
	else:
		flicker_idx -= delta

func _on_timer_timeout():
	light_energy = 1.5
