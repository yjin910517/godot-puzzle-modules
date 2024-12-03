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
	
	forward_speed = 700
	backward_speed = 10


func _process(delta):
	if is_reacting:
		# grow the energy bar when the key is pressed
		if Input.is_action_just_pressed("stir_smash"):
			key.play("smash")
			smash_started = true
			
			if energy_bar.size.x + forward_speed * delta <= max_target:
				energy_bar.size.x += forward_speed * delta
			else:
				energy_bar.size.x = max_target
				is_reacting = false
				print("Egg well stirred!")
		
		# decrease the energy bar at a constant speed
		if smash_started:
			if energy_bar.size.x - backward_speed * delta > 0:
				energy_bar.size.x -= backward_speed * delta
			else: 
				energy_bar.size.x = 0
				is_reacting = false
				print("Mission failed")
