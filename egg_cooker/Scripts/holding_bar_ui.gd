extends Control


@onready var ticker = $Ticker

var speed
var is_ticker_reacting
var is_ticker_reversible


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 50
	is_ticker_reacting = true
	is_ticker_reversible = true


func _process(delta):
	# move ticker when space key is held
	if Input.is_action_pressed("hold_space"):
		if is_ticker_reacting:
			if ticker.position.x + speed * delta <= size.x:
				ticker.position.x += speed * delta
			else:
				ticker.position.x = size.x
				is_ticker_reversible = false
				is_ticker_reacting = false
				print("Failed to release")
				
	# if space is released inside buffer zone, ticker will move backward and stop at origin
	elif is_ticker_reversible:
		if ticker.position.x - speed * delta > 0:
			ticker.position.x -= speed * delta
		else:
			ticker.position.x = 0
		
	# if space key is released in lock-in zone. 
	if Input.is_action_just_released("hold_space"):
		# change to a method on bar object and a function for range evaluation
		if ticker.position.x >= 200:
			print("Space was released at ", ticker.position.x)
			is_ticker_reversible = false
			is_ticker_reacting = false
