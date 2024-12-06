extends Control


@onready var shelf = $Shelf
@onready var ticker = $Shelf/Ticker
@onready var anime = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anime.play("start_end")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drum_kick"):
		print("Kick at ", round(ticker.position.x))
