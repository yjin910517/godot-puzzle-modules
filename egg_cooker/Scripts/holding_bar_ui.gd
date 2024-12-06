extends Control


signal success_input(ui_node)
signal failed_input(ui_node)


@onready var bar = $Bar
@onready var target = $Target
@onready var ticker = $Ticker

var speed
var bar_max_len
var ticker_offset
var is_ticker_reacting
var is_ticker_reversible

var target_lower
var target_upper

# bar parameters dataset
var bar_data = {
	"target_pos": 232,
	"speed": 200
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initiate_bar(bar_data)


func initiate_bar(bar_data):
	speed = bar_data["speed"]
	target.position.x = bar_data["target_pos"]
	target_lower = target.position.x 
	target_upper = target_lower + target.size.x * target.scale.x
	bar_max_len = bar.size.x * bar.scale.x
	ticker_offset = ticker.size.x * ticker.scale.x

	is_ticker_reacting = true
	is_ticker_reversible = true
	

func _process(delta):
	# move ticker when space key is held
	if is_ticker_reacting:
		if Input.is_action_pressed("hold_space"):
			if ticker.position.x + ticker_offset + speed * delta <= bar_max_len:
				ticker.position.x += speed * delta
			else:
				ticker.position.x = bar_max_len - ticker_offset
				is_ticker_reversible = false
				is_ticker_reacting = false
				print("Failed to release")
				emit_signal("failed_input", self)
					
		# if space is released inside buffer zone, ticker will move backward and stop at origin
		elif is_ticker_reversible:
			if ticker.position.x - speed * delta > 0:
				ticker.position.x -= speed * delta
			else:
				ticker.position.x = 0
		
		# if space key is released in lock-in zone. 
		if Input.is_action_just_released("hold_space"):
			# turn off reversible if the ticker is out of the buffer zone
			if ticker.position.x + ticker_offset >= 20:
				print("Space was released at ", ticker.position.x + ticker_offset)
				is_ticker_reversible = false
				is_ticker_reacting = false
				
				var current_pos = ticker.position.x + ticker_offset/2
				if current_pos < target_lower:
					print("Released too early")
					emit_signal("failed_input", self)
				elif current_pos <= target_upper:
					print("Success!")
					emit_signal("success_input", self)
				else:
					print("Released too late")
					emit_signal("failed_input", self)									
