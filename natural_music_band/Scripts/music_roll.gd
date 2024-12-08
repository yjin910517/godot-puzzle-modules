extends Control


@onready var ticker = $Ticker
@onready var anime = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func play_rolling():
	anime.play("start_end")
	

func get_ticker_x():
	return ticker.position.x
