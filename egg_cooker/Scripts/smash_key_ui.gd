extends Control


signal success_input(ui_node)
signal failed_input(ui_node)


@onready var key = $KeyIcon
@onready var energy_bar = $EnergyBar

var is_reacting
var smash_started
var forward_speed
var backward_speed

const max_target = 200

var bar_data = {
	"forward_speed": 1200,
	"backward_speed": 20
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initiate_bar(bar_data)


func initiate_bar(bar_data):
	is_reacting = true
	smash_started = false

	forward_speed = bar_data["forward_speed"]
	backward_speed = bar_data["backward_speed"]
	
	energy_bar.step = 0.1
	energy_bar.max_value = max_target
	energy_bar.value = 0
	

func _process(delta):
	if is_reacting:
		# grow the energy bar when the key is pressed
		if Input.is_action_just_pressed("stir_smash"):
			key.play("smash")
			smash_started = true
			
			if energy_bar.value + forward_speed * delta <= max_target:
				energy_bar.value += forward_speed * delta
			else:
				energy_bar.value = max_target
				is_reacting = false
				print("Egg well stirred!")
				emit_signal("success_input", self)
		
		# decrease the energy bar at a constant speed
		if smash_started:
			if energy_bar.value - backward_speed * delta > 0:
				energy_bar.value -= backward_speed * delta
			else: 
				energy_bar.value = 0
				is_reacting = false
				print("Mission failed")
				emit_signal("failed_input", self)
