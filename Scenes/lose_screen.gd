extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.MapNode = null
	Globals.Player = null

	Globals.current_food_objective = 4

	Globals.progression_level = 0

	Globals.ProgressionFirstDoor = false
	Globals.ProgressionSecondDoor = false

	Globals.LearnedFlashlight = false

	Globals.monster_retreat_point = Vector3.ZERO
	Globals.current_value = 0
	
	Globals.backpack_upgrades = 0
	Globals.stamina_upgrades = 0
	Globals.current_backpack_bonus = 0
	Globals.current_stamina_bonus = 0
	Globals.energy_drink_active = false
	
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
