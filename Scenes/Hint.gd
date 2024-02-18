extends Control

@export var hint_time : float = 5.0
@onready var hint_label = $MarginContainer/VBoxContainer/Panel/MarginContainer/HintLabel
@onready var timer = $HintTimer

func _ready():
	visible = false

func hide_hint():
	visible = false
	timer.stop()

func show_hint(text):
	if !text:
		return
	hint_label.text = str(text)
	visible = true
	timer.start()

func _on_hint_timer_timeout():
	visible = false
