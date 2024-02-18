extends Node3D
class_name Door

@onready var anim_player = $AnimationPlayer2
@export var reverse_anim : bool = false

var open : bool = false

func on_interact():
	print("amogu")
	if not reverse_anim:
		if not open:
			anim_player.play("open_door")
			open = true
			return
		else:
			anim_player.play("close_door")
			open = false
	else:
		# REVERSED ANIMS
		if not open:
			anim_player.play("open_door_reverse")
			open = true
			return
		else:
			anim_player.play("close_door_reverse")
			open = false
