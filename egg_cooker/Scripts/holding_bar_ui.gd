extends Control


@onready var bar = $Bar
@onready var ticker = $Ticker

var speed
var bar_milestones
var bar_max_len
var ticker_offset
var is_ticker_reacting
var is_ticker_reversible

# bar parameters dataset
var bar_data = {
	"texture": load("res://Arts/holding_bar_1.png"),
	"milestones": [
		24.0/224.0 # gray to red
	  , 56.0/224.0 # red to yellow
	  , 88.0/224.0 # yellow to green
	  , 116.0/224.0 # green to yellow
	  , 144.0/224.0 # yellow to red
	],
	"speed": 50
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initiate_bar(bar_data)
	print(bar_milestones)


func initiate_bar(bar_data):
	speed = bar_data["speed"]
	bar.texture = bar_data["texture"]
	bar_milestones = bar_data["milestones"]
	bar_max_len = bar.size.x * bar.scale.x
	ticker_offset = ticker.size.x * ticker.scale.x / 2
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
					
		# if space is released inside buffer zone, ticker will move backward and stop at origin
		elif is_ticker_reversible:
			if ticker.position.x + ticker_offset - speed * delta > 0:
				ticker.position.x -= speed * delta
			else:
				ticker.position.x = 0 - ticker_offset
		
		# if space key is released in lock-in zone. 
		if Input.is_action_just_released("hold_space"):
			# turn off reversible if the ticker is out of the buffer zone
			if ticker.position.x + ticker_offset >= bar_max_len * bar_milestones[0]:
				print("Space was released at ", ticker.position.x + ticker_offset)
				is_ticker_reversible = false
				is_ticker_reacting = false
