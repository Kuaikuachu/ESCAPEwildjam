extends Control

@onready var text_manager = $MarginContainer/TextPanel/MarginContainer/VBoxContainer

@onready var funds_label = $MarginContainer/FundsLabel

var can_buy : bool = false


func _ready():
	Globals.progression_level += 1
	randomize()
	Globals.current_value += (randi_range(25,75) * Globals.progression_level)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print(Globals.progression_level)
	
	await get_tree().create_timer(1.0).timeout
	if Globals.progression_level == 1:
		text_manager.create_text("We assessed your work and allocated you a reasonable amount of funds.")
		await get_tree().create_timer(3.0).timeout
		text_manager.create_text("We can give you some of our belongings for those funds.")
		
		await get_tree().create_timer(2.0).timeout
		can_buy = true
		return
	if Globals.progression_level == 3:
		text_manager.create_text("There's no survival for us.")
		await get_tree().create_timer(3.0).timeout
		text_manager.create_text("We're just trying to get through a couple more days. We will all perish in the end.")
		await get_tree().create_timer(3.0).timeout
		text_manager.create_text("Thanks for your job.")
		
		await get_tree().create_timer(2.0).timeout
		can_buy = true
		return
	if Globals.progression_level == 2 or Globals.progression_level > 3:
		text_manager.create_text("Welcome back.")
		await get_tree().create_timer(2.0).timeout
		can_buy = true
		return

func _physics_process(_delta):
	funds_label.text = str(Globals.current_value)

func purchase_text():
	var phrases : Array = ["We hope it comes in handy.", "Thanks for your purchase.", "Hope it helps.", "It might be worth more to you than us"]
	phrases.shuffle()
	text_manager.create_text(phrases[0])
	

func _on_backpack_price_button_button_up():
	purchase_text()

func _on_proceed_button_up():
	get_tree().change_scene_to_file("res://Scenes/Test.tscn")
