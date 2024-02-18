extends AudioStreamPlayer

@export var sounding : bool = true
var limit : float = 0

func _process(delta):
	if sounding and limit == 0:
		play()
		limit = 0.1
	
	if limit > 0.0:
		limit -= delta
		if limit <= 0.0:
			limit = 0.0
