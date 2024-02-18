extends Node3D

@onready var world_environment = $WorldEnvironment
var environment

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	environment = world_environment.get_environment()
	
	$Main.visible = true
	$Main/Settings.visible = false
	$SpotLight3D.visible = false

func _physics_process(_delta):
	environment.tonemap_exposure = Globals.Brightness

func _on_startuptimer_timeout():
	$SpotLight3D.visible = true


func _on_play_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")


func _on_settings_button_button_up():
	$Main.visible = false
	$Main/Settings.visible = true

func _on_exit_button_button_up():
	get_tree().quit()

func close_settings():
	$Main/Settings.visible = false
	$Main.visible = true

func _on_timer_timeout():
	if $AudioStreamPlayer.playing != true:
		$AudioStreamPlayer.playing = true


func _on_spin_box_value_changed(value):
	pass # Replace with function body.
