extends Node3D

@onready var world_environment = $Environment/WorldEnvironment
@onready var game_timer = $game_timer
@onready var item_spawn_manager = $ItemSpawnManager
@onready var monster_spawns = $monster_spawns
@onready var monster_warning = $monster_warning
@onready var monster_spawn_delay = $monster_spawn_delay
@onready var wall_crush = $wall_crush
@onready var vault_animation = $vault_door/AnimationPlayer
@onready var monster_retreat_point = $monster_retreat_point

var progression_level : int = 0

const monster = preload("res://Scenes/monster.tscn")

var environment

# Called when the node enters the scene tree for the first time.
func _init():
	progression_level = Globals.progression_level
	Globals.current_food_objective = 4 + (progression_level * 3)
	
	if progression_level == 0:
		Globals.ProgressionFirstDoor = false
		Globals.ProgressionSecondDoor = false
	elif progression_level == 1:
		Globals.ProgressionFirstDoor = true
		Globals.ProgressionSecondDoor = false
	elif progression_level >= 2:
		Globals.ProgressionFirstDoor = true
		Globals.ProgressionSecondDoor = true

func _ready():
	Globals.MapNode = self
	Globals.monster_retreat_point = monster_retreat_point.global_position
	
	item_spawn_manager.guaranteed_amount_big = item_spawn_manager.guaranteed_amount_big + (progression_level*2)
	item_spawn_manager.guaranteed_amount_small = item_spawn_manager.guaranteed_amount_small + (progression_level * 4)
	
	item_spawn_manager.food_min = Globals.current_food_objective + 3
	
	environment = world_environment.get_environment()
	environment.ambient_light_energy = 0.0
	environment.tonemap_exposure = Globals.Brightness
	
func _physics_process(_delta):
	environment.tonemap_exposure = Globals.Brightness
	if Input.is_action_just_pressed("escape") and Globals.Player.playable == false:
		skip_cutscene()
	if $ambience.playing == false:
		$ambience.play(0)

func start_vaulting():
	$vault_door/AnimationPlayer.play("door_open")

func skip_cutscene():
	$vault_door/AnimationPlayer.play("door_open_skip")
	Globals.Player.camera.current = true
	Globals.Player.ui_manager.skip_ui_animation()
	Globals.Player.HUD.visible = true
	await get_tree().create_timer(0.5).timeout
	Globals.Player.playable = true
	set_process_unhandled_key_input(false)
	
	start_game()

func start_game():
	item_spawn_manager.initialize_spawning()
	game_timer.wait_time += (progression_level*5)
	game_timer.start()

func _on_game_timer_timeout():
	monster_warning.play()
	monster_spawn_delay.start()

func spawn_monster():
	var furthest_point : Vector3
	var player_pos = Globals.Player.global_position
	for node in monster_spawns.get_children():
		var pos = node.global_position
		if !furthest_point:
			furthest_point = pos
			continue
		if player_pos.distance_to(pos) > player_pos.distance_to(furthest_point):
			furthest_point = pos
	var demon = monster.instantiate()
	add_child(demon)
	demon.global_position = furthest_point
	
	wall_crush.global_position = demon.global_position
	wall_crush.play()

func _on_monster_spawn_delay_timeout():
	spawn_monster()


func _on_safe_area_area_entered(area):
	if Globals.Player:
		if Globals.Player.enough_food == true:
			vault_animation.play("door_close")
			Globals.Player.safe = true
			await get_tree().create_timer(7).timeout
			if Globals.Player.safe == true:
				Globals.current_value += Globals.Player.current_value
				get_tree().change_scene_to_file("res://Scenes/hub_screen.tscn")

func _on_safe_area_area_exited(area):
	if Globals.Player:
		if Globals.Player.enough_food == true:
			Globals.Player.safe = false
