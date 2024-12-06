extends Control


signal success_input(ui_node)
signal failed_input(ui_node)


@onready var timer = $Countdown

var countdown_time # Total countdown duration
var time_left
var input_mapping

var key_data = {
	"time": 5,
	"key_texture": load("res://Arts/countdown_key_over.png"),
	"input_mapping": "timed_press" # configuared in project setting
}


func _ready():
	initiate_key(key_data)
	

func initiate_key(key_data):
	countdown_time = key_data["time"]
	time_left = countdown_time
	timer.texture_over =  key_data["key_texture"]
	input_mapping = key_data["input_mapping"]
	
	timer.step = 0.01  # Set the step small enough to detect delta change
	timer.max_value = countdown_time # Set the max value of the timer
	timer.value = countdown_time # Start the timer fully filled
	
	set_process(true)


func _process(delta):
	if Input.is_action_pressed(input_mapping):
		set_process(false)
		_on_success_press()
	elif time_left > 0:
		time_left -= delta
		timer.value = time_left
	else:
		set_process(false)  # Stop updating when time is up
		_on_time_out()       # Handle timeout logic


func _on_success_press():
	print("Success!")
	emit_signal("success_input", self)
	
	
func _on_time_out():
	print("Time's up! Mission failed.")
	emit_signal("failed_input", self)
