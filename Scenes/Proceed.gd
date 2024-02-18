extends Button


func _physics_process(_delta):
	if Globals.progression_level == 3:
		text = "endless"
	
	if $"../..".can_buy == false:
		disabled = true
	else:
		disabled = false
