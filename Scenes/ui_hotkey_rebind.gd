class_name HotkeyRebindButton
extends Control

@onready var button = $HBoxContainer/Rebinder
@onready var reset = $HBoxContainer/Reset

@export var action_name : String = "left"
@export var default_action_button : InputEvent



func _ready():
	set_process_unhandled_key_input(false)
	set_text_for_key()

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text = "%s" % action_keycode
	
func _on_rebinder_toggled(button_pressed):
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(button_pressed)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
		
	else:
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
			
		set_text_for_key()


func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()

func _on_button_pressed():
	pass # Replace with function body.

func _on_reset_pressed():
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, default_action_button)
	set_process_unhandled_key_input(false)
	set_text_for_key()
