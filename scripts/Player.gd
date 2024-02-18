extends CharacterBody3D

@onready var head = $shoulder/neck/head
@onready var neck = $shoulder/neck
@onready var shoulder = $shoulder
@onready var stamina_bar = $CanvasLayer/Control/MarginContainer/VBoxContainer/StaminaBar
@onready var stamina_bar_depleted = $CanvasLayer/Control/MarginContainer/VBoxContainer2/StaminaBarDepleted
@onready var camera = $shoulder/neck/head/Camera3D
@onready var collision = $CollisionShape3D
@onready var ui_manager = $UIManager

@onready var hint = $CanvasLayer/Hint
@onready var give_flashlight_hint = $GiveFlashlightHint

@onready var flashlight = $flashlight_holder/flashlight
@onready var flashlight_holder = $flashlight_holder

@onready var HUD = $CanvasLayer
@onready var cursor_icons = $CanvasLayer/Control/MarginContainer/icons

@onready var step_sound = $step
var step_sound_interval_base = 0.5
var step_sound_timer = 0.3
var step_sound_velocity_multiplier = 0.19

# 0 = cursor
# 1 = bag
# 2 = door
# 3 = no_bag
var current_icon : int = 0
var visible_icon : int = 0

# counter vars
@onready var current_food_label = $CanvasLayer/Control2/MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer2/current
@onready var required_food_label = $CanvasLayer/Control2/MarginContainer/VBoxContainer/Panel/MarginContainer/HBoxContainer2/required
@onready var weneedmore = $CanvasLayer/Control2/MarginContainer/VBoxContainer/Panel2/MarginContainer/weneedmore
@onready var escape = $CanvasLayer/Control2/MarginContainer/VBoxContainer/Panel2/MarginContainer/escape
@onready var intro_anim = $UIManager/AnimationPlayer

@onready var settings_ui = $CanvasLayer/Settings

@export var start_vaulting = false

# CUTSCENES
var playable : bool = false
var camera_control : bool = true
var can_move : bool = true
var safe : bool = false

# FLASHLIGHT
var flash_short_range : float = 13.0
var flash_short_angle : float = 40
var flash_long_range : float = 45.0
var flash_long_angle : float = 25
var flash_current : Vector2

var flash_toggle_time : float = 0.25
var flash_time_idx : float = 0.0

# FLASHLIGHT STATES
var flash_long = false
var flash_short = false
var flash_off = false

var flashlight_allowed : bool = false

# SACK VALUES
var current_weight : int = 0
var current_value : int = 0
var max_weight : int = 50
var current_weight_multiplier : float = 1.0
var lowest_weight_multiplier : float = 0.3

var food_items_held : int = 0
var enough_food : bool = false

# STATES
var moving = false
var running = false

var current_speed = 3.5
var default_speed = 3.5
const running_speed_multiplier = 1.8

const jump_velocity = 5.5 

var mouse_sens = 0.31

const no_input_lerp = 10.0
const input_lerp = 4.5
var current_lerp_speed = 4.5

# stamina values
var current_stamina : float = 100.0
var max_stamina : float = 100.0

var current_stamina_regen : float = 0.5 # ACCELERATES
var stamina_regen_acceleration : float = 0.4
var stamina_regen_delay : float = 1.0
var stamina_regen_timer : float = 0.0

var stamina_run_consumption : float = 0.45
var running_disabled_until_stamina : bool = false

# headbob
const head_bobbing_sprinting_speed = 14.4 
const head_bobbing_walking_speed = 8.0

const head_bobbing_sprinting_intensity = 0.2
const head_bobbing_walking_intensity = 0.1

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0

# SMOOTH CAMERA
var camera_pos_last : Vector3

var direction = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 1.5

func _ready():
	if Globals.backpack_upgrades > 0:
		max_weight += Globals.backpack_upgrades*30
	if Globals.stamina_upgrades > 0:
		current_stamina = 100 + (Globals.stamina_upgrades * 40)
	if Globals.energy_drink_active:
		default_speed = 4.2
	
	if Globals.progression_level == 0:
		intro_anim.play("first")
	
	weneedmore.visible = true
	escape.visible = false
	
	current_food_label.text = str(food_items_held)
	required_food_label.text = str(Globals.current_food_objective)
	
	Globals.Player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_sens = Globals.MouseSensitivity
	
	flashlight_allowed = true
	HUD.visible = false

func _input(event):
	if not playable:
		return
	if event is InputEventMouseMotion and camera_control:
		shoulder.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		collision.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		neck.rotate_x(deg_to_rad(-event.relative.y) * mouse_sens)
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	flashlight_holder.rotation.y = lerp_angle(flashlight_holder.rotation.y, camera.global_rotation.y, 10*delta)
	flashlight_holder.rotation.x = lerp_angle(flashlight_holder.rotation.x, camera.global_rotation.x, 10*delta)
	flashlight_holder.rotation.z = lerp_angle(flashlight_holder.rotation.z, camera.global_rotation.z, 10*delta)
	move_and_slide()

func _physics_process(delta):
	if !playable and Globals.progression_level > 0:
		playable = true
		get_parent().skip_cutscene()
	
	if current_icon != visible_icon:
		visible_icon = current_icon
		change_icon()
		
	if start_vaulting:
		start_vaulting = false
		get_parent().start_vaulting()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("toggle_flashlight") and playable:
		if flash_time_idx == 0 and flashlight_allowed:
			Globals.LearnedFlashlight = true
			$flashlight_click.playing = true
			hint.hide_hint()
			give_flashlight_hint.stop()
			if flash_short: # LONG NEXT
				flash_short = false
				flash_long = true
				flashlight.spot_range = 0.0
				flash_time_idx = flash_toggle_time
				flash_current.x = flash_long_range
				flash_current.y = flash_long_angle
				
			else:
				flash_short = true
				flash_long = false
				flashlight.spot_range = 0.0
				flash_time_idx = flash_toggle_time
				flash_current.x = flash_short_range
				flash_current.y = flash_short_angle
		
	if flash_time_idx > 0.0:
		flash_time_idx -= delta
	else:
		flash_time_idx = 0.0
		flashlight.spot_range = flash_current.x
		flashlight.spot_angle = flash_current.y
	
	# FULL STAMINA
	if current_stamina >= max_stamina:
		current_stamina = max_stamina
		running_disabled_until_stamina = false
	
	else:
		if current_stamina <= 0.0:
			running_disabled_until_stamina = true
		# NOT FULL
		if stamina_regen_timer <= 0.0:
			current_stamina_regen += stamina_regen_acceleration * delta
			current_stamina += current_stamina_regen
	
	if Input.is_action_pressed("run") and not running_disabled_until_stamina and moving:
		running = true
		current_speed = default_speed * running_speed_multiplier * current_weight_multiplier
		if current_speed < 0.3:
			current_speed = 0.3
		
		stamina_regen_timer = stamina_regen_delay
		current_stamina_regen = 0.0
		
		if not running_disabled_until_stamina:
			current_stamina -= stamina_run_consumption
	else:
		running = false
		current_speed = default_speed * current_weight_multiplier
		if current_speed < 0.3:
			current_speed = 0.3
		if stamina_regen_timer == 0.0:
			stamina_regen_timer = stamina_regen_delay
		else:
			stamina_regen_timer -= delta
		
	# update stamina bar
	stamina_bar.value = (current_stamina/max_stamina)*100
	stamina_bar_depleted.value = (current_stamina/max_stamina)*100
	
	# show red version
	if running_disabled_until_stamina:
		stamina_bar_depleted.visible = true
	else:
		stamina_bar_depleted.visible = false
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	if input_dir:
		current_lerp_speed = input_lerp
	else:
		current_lerp_speed = no_input_lerp
	
	# DONT DO MOVEMENT IF NOT CONTROLLED
	if not playable:
		move_and_slide() 
		return
	# IS PLAYABLE
	else:
		if not Globals.LearnedFlashlight and give_flashlight_hint.is_stopped():
			give_flashlight_hint.start()

	
	if Input.is_action_just_pressed("escape"):
		if settings_ui.visible == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			camera_control = false
			can_move = false
			settings_ui.visible = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			camera_control = true
			can_move = true
			settings_ui.visible = false
	
	if can_move:
		direction = lerp(direction,(shoulder.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*current_lerp_speed)
	else:
		direction = lerp(direction,Vector3.ZERO,delta*current_lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	if step_sound_timer > 0.0:
		step_sound_timer -= delta * velocity.length() * step_sound_velocity_multiplier
	else:
		step_sound_timer = step_sound_interval_base
		step_sound.play()
		
	if direction.length() > 0.4:
		moving = true
	else:
		moving = false
		
	# HEADBOB
	if running:
		head_bobbing_current_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed*delta*current_weight_multiplier
	else:
		head_bobbing_current_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed*delta*current_weight_multiplier
	if is_on_floor() && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2)+0.5
		
		head.position.y = lerp(head.position.y, head_bobbing_vector.y*head_bobbing_current_intensity,delta*current_lerp_speed*direction.length())
		head.position.x = lerp(head.position.x, head_bobbing_vector.x*head_bobbing_current_intensity/2.0,delta*current_lerp_speed*direction.length())
	else:
		head.position.y = lerp(head.position.y,0.0,delta*current_lerp_speed)
		head.position.x = lerp(head.position.x,0.0,delta*current_lerp_speed)

func add_to_sack(weight, value):
	current_weight += weight
	current_value += value
	# change speed from weight
	current_weight_multiplier = 1.0 - ((1.0-lowest_weight_multiplier) * current_weight / max_weight)

func close_settings():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_control = true
	can_move = true
	settings_ui.visible = false

func food_item_picked_up():
	food_items_held += 1
	if food_items_held >= Globals.current_food_objective:
		weneedmore.visible = false
		escape.visible = true
		enough_food = true
	
	current_food_label.text = str(food_items_held)
	pass

func change_icon():
	for icon in cursor_icons.get_children():
		if icon.get_index() == current_icon:
			icon.visible = true
		else:
			icon.visible = false
		
func _on_give_flashlight_hint_timeout():
	var action_events = InputMap.action_get_events("toggle_flashlight")
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	hint.show_hint("Press " + action_keycode + " for flashlight")
