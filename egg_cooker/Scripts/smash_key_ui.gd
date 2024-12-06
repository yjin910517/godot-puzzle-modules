extends Control


@onready var key = $KeyIcon
@onready var energy_bar = $EnergyBar


const max_target = 200

var is_reacting
var smash_started

var forward_speed
var backward_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	is_reacting = true
	smash_started = false
	
	energy_bar.max_value = max_target
	energy_bar.value = 0
	
	forward_speed = 1200
	backward_speed = 20


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
		
		# decrease the energy bar at a constant speed
		if smash_started:
			print("value", energy_bar.value )
			print("change", backward_speed * delta)
			if energy_bar.value - backward_speed * delta > 0:
				energy_bar.value -= backward_speed * delta
			else: 
				energy_bar.value = 0
				is_reacting = false
				print("Mission failed")
