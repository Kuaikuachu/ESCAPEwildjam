extends Button

@onready var hub_screen = $"../../../../../../../.."

var current_price : int = 0
var base_price : int = 100
var price_increase : int = 50

var sold : bool = false

func _physics_process(_delta):
	if sold:
		disabled = true
		text = "Sold!"
		return
	current_price = base_price + Globals.progression_level*price_increase
	text = str(current_price)
	
	if Globals.current_value < current_price or hub_screen.can_buy == false:
		disabled = true
	else:
		disabled = false
	
func _on_button_up():
	Globals.current_value -= current_price
	Globals.energy_drink_active = true
	sold = true
