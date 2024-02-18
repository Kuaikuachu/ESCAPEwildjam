class_name UserPreferences extends Resource

@export var WindowMode : int = 4
@export var Resolution : int = 0
@export var Volume : int = 0
@export var MouseSensitivity : float = 0.31
@export var Brightness : float = 1
@export var FPS : int = 60
@export var action_events: Dictionary = {}

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
