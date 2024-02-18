extends Camera3D

@export var move_camera : bool = false

func _physics_process(delta):
	fov = Globals.Player.camera.fov 
	
	if not move_camera or not Globals.Player.camera.global_position:
		return
	global_position = lerp(global_position, Globals.Player.camera.global_position, 2*delta)
	global_rotation.x = lerp_angle(global_rotation.x, Globals.Player.camera.global_rotation.x, 2*delta)
	global_rotation.y = lerp_angle(global_rotation.y, Globals.Player.camera.global_rotation.y, 2*delta)
	global_rotation.z = lerp_angle(global_rotation.z, Globals.Player.camera.global_rotation.z, 2*delta)
	if global_position.distance_to(Globals.Player.camera.global_position) < 0.02:
		Globals.Player.camera.current = true
		Globals.Player.playable = true
		Globals.Player.HUD.visible = true
		get_parent().start_game()
		queue_free()
