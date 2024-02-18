extends RayCast3D

var hovered : Node3D


func _process(_delta):
	var player = Globals.Player
	if is_colliding():
		if get_collider():
			hovered = get_collider().get_parent()
		
		if hovered is Collectible:
			if player.current_weight + hovered.object_weight > player.max_weight:
				# no bag icon
				player.current_icon = 3
			else:
				# bag icon
				player.current_icon = 1
		elif hovered is Door:
			player.current_icon = 2
		
		if Input.is_action_just_pressed("interact") and hovered:
			if hovered is Door:
				hovered.on_interact()
				
			if hovered is Collectible:
				if player.current_weight + hovered.object_weight <= player.max_weight or hovered.food_item == true:
					if hovered.food_item == true:
						player.food_item_picked_up()
					
					$"../../../../pick_up".play(0.35)
					player.add_to_sack(hovered.object_weight, hovered.object_value)
					hovered.queue_free()
					hovered = null

	else:
		player.current_icon = 0
		if hovered:
			hovered = null
			
