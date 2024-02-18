extends Button

@onready var hub_screen = $"../../../../../../../.."

var current_price : int = 0
var base_price : int = 175
var price_increase : int = 75

func _physics_process(_delta):
	current_price = base_price + Globals.stamina_upgrades*price_increase
	text = str(current_price)
	
	if Globals.current_value < current_price or hub_screen.can_buy == false:
		disabled = true
	else:
		disabled = false
	
func _on_button_up():
	Globals.current_value -= current_price
	Globals.stamina_upgrades += 1
