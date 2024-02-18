extends Node3D
class_name Collectible

@export var self_destruct : bool 

@export var object_weight = 0.0
@export var object_value_low = 0.0
@export var object_value_high = 0.0

@export var food_item : bool = false

enum progression_door { NONE , FIRST , SECOND } 
@export var progression: progression_door

var object_value

var highlit = false

func _ready():
	object_value = randi_range(object_value_low,object_value_high)
	if (progression == 2 and Globals.ProgressionSecondDoor == false) or (progression == 1 and Globals.ProgressionFirstDoor == false):
		get_parent().queue_free()
		return
	
	if self_destruct:
		queue_free()
