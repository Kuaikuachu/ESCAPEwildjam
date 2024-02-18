extends Node2D

func start_ui_animation():
	$AnimationPlayer.play("first")

func skip_ui_animation():
	$AnimationPlayer.play("RESET")
