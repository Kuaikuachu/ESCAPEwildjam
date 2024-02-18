extends Node

var MapNode : Node3D
var Player : CharacterBody3D

var current_food_objective : int = 4

var progression_level : int = 0

var ProgressionFirstDoor = false
var ProgressionSecondDoor = false

var LearnedFlashlight = false

var monster_retreat_point : Vector3

var current_value : int = 0

#UPGRADES
var backpack_upgrades : int = 0
var current_backpack_bonus : int = 0
var stamina_upgrades = 0
var current_stamina_bonus : int = 0
var energy_drink_active : bool = false

# 4 = FullBord
# 3 = Full
# 0 = Wind
var WindowMode = 3

# 0 = 1920x1080
# 1 = 1366x768
# 2 = 1280x1024
# 3 = 1440x900
# 4 = 1600x900
# 5 = 1680x1050
# 6 = 1280x800
# 7 = 1024x768
# 8 = 2560x1140
# 9 = 3840x2160
var Resolution = 0

# something - something
var Volume = 0

# 0 - 100
var MouseSensitivity = 0.31

# 0 - 100
var Brightness = 1

var FPS = 60
