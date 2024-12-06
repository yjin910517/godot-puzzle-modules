extends Control


signal success_pressed()
signal failed_to_press()


@onready var timer = $Countdown

const scaler = 10 # To give progress radial smoother change

var countdown_time # Total countdown duration
var time_left


func _ready():
	countdown_time = 5.0
	time_left = countdown_time
	
	timer.max_value = countdown_time * scaler  # Set the max value of the timer
	timer.value = countdown_time * scaler     # Start the timer fully filled
	set_process(true)


func _process(delta):
	if Input.is_action_pressed("timed_press"):
		set_process(false)
		_on_success_press()
	elif time_left > 0:
		time_left -= delta
		timer.value = time_left * scaler
	else:
		set_process(false)  # Stop updating when time is up
		_on_time_out()       # Handle timeout logic


func _on_success_press():
	print("Success!")
	emit_signal("success_pressed")
	
	
func _on_time_out():
	print("Time's up! Mission failed.")
	emit_signal("failed_to_press")
