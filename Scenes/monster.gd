extends CharacterBody3D

var speed = 8
var accel = 10

@onready var nav = $NavigationAgent3D
@onready var model = $Model

@onready var animation_player = $Model/monster/AnimationPlayer
@onready var sound = $AudioStreamPlayer3D

@export var play_sound : bool = false

func _ready():
	animation_player.play("leg1Left_002")

func _physics_process(delta):
	if !Globals.Player:
		return
	
	if play_sound:
		play_sound = false
		sound.play(0.3)
	
	var direction = Vector3()
	
	nav.target_position = Globals.Player.global_position
	if Globals.Player.safe:
		nav.target_position = Globals.monster_retreat_point
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)
	
	look_at(nav.target_position, Vector3.UP)
	
	move_and_slide()


func _on_area_3d_area_entered(area):
	game_over()

func game_over():
	get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")
