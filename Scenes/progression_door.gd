extends Node3D

@export var first_progression : bool = false
@export var second_progression : bool = false

func _physics_process(_delta):
	if Globals.ProgressionFirstDoor == true and first_progression == true:
		queue_free()
	if Globals.ProgressionSecondDoor == true and second_progression == true:
		queue_free()
