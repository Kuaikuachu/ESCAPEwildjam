extends VBoxContainer
@onready var audio_stream_player = $AudioStreamPlayer

var text_scene = preload("res://Scenes/text_scene.tscn")


func play_sound():
	audio_stream_player.sounding = true
	await get_tree().create_timer(1.0).timeout
	audio_stream_player.sounding = false

func create_text(text):
	var new_text = text_scene.instantiate()
	new_text.text = text
	add_child(new_text)
