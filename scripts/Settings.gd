extends CanvasLayer

@onready var window_option = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/WindowOption

@onready var res_options = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/ResOptions

@onready var volume_slider = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/MarginContainer/VolumeSlider
@onready var tone = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/MarginContainer/VolumeSlider/AudioStreamPlayer
@onready var tone_delay = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/MarginContainer/VolumeSlider/ToneDelay

@onready var sens_slider = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/MarginContainer2/SensSlider

@onready var bright_slider = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/MarginContainer3/BrightSlider

@onready var spin_box = $MarginContainer/Panel/MarginContainer/TabContainer/general/MarginContainer/Right/MarginContainer4/SpinBox

var user_prefs: UserPreferences

var Resolutions: Dictionary = {0:Vector2i(1920,1080),
								1:Vector2i(1366,768),
								2:Vector2i(1280,1024),
								3:Vector2i(1440,900),
								4:Vector2i(1600,900),
								5:Vector2i(1680,1050),
								6:Vector2i(1280,800),
								7:Vector2i(1024,768),
								8:Vector2i(2560,1440),
								9:Vector2i(3840,2160)}

func _ready():
	user_prefs = UserPreferences.load_or_create()
	
	Globals.WindowMode = user_prefs.WindowMode
	Globals.Resolution = user_prefs.Resolution
	Globals.Volume = user_prefs.Volume
	Globals.MouseSensitivity = user_prefs.MouseSensitivity
	Globals.Brightness = user_prefs.Brightness
	Globals.FPS = user_prefs.FPS
	
	window_option.selected = Globals.WindowMode
	res_options.selected = Globals.Resolution
	volume_slider.value = Globals.Volume
	sens_slider.value = Globals.MouseSensitivity
	bright_slider.value = Globals.Brightness
	spin_box.value = Globals.FPS
	
	if Globals.WindowMode == 0:
		res_options.disabled = false
	else:
		res_options.disabled = true

func _on_window_option_item_selected(index):
	Globals.WindowMode = window_option.get_item_id(index)
	if index == 0:
		res_options.disabled = false
	else:
		res_options.disabled = true

func _on_res_options_item_selected(index):
	Globals.Resolution = index

func _on_volume_slider_drag_started():
	tone_delay.start()

func _on_volume_slider_drag_ended(value_changed):
	tone_delay.stop()

func _on_tone_delay_timeout():
	tone.play()

func _on_volume_slider_value_changed(value):
	Globals.Volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)



func _on_sens_slider_value_changed(value):
	Globals.MouseSensitivity = value

func _on_bright_slider_value_changed(value):
	Globals.Brightness = value

func _on_button_button_up():
	visible = false
	get_parent().get_parent().close_settings()

func _on_apply_button_up():
	var res = Resolutions.get(Globals.Resolution)
	var window = get_window()
	var window_mode = Globals.WindowMode
	var max_fps = Globals.FPS
	var player = Globals.Player
	var sens = sens_slider.value
	
	if player:
		player.mouse_sens = sens
	
	Engine.max_fps = max_fps
	
	if window.get_mode() != window_mode:
		if window_mode == 4:
			res = DisplayServer.window_get_size()
			window.set_mode(4)
		elif window_mode == 3:
			window.set_mode(3)
		elif window_mode == 0:
			window.set_mode(0)
	
	if window.get_size() == res:
		print("same size")
	else:
		window.set_size(res)

func _on_save_button_up():
	_on_apply_button_up()
	user_prefs.WindowMode = Globals.WindowMode
	user_prefs.Resolution = Globals.Resolution
	user_prefs.Volume = Globals.Volume
	user_prefs.MouseSensitivity = Globals.MouseSensitivity
	user_prefs.Brightness = Globals.Brightness
	user_prefs.FPS = Globals.FPS
	user_prefs.save()

func _on_spin_box_value_changed(value):
	Globals.FPS = value
