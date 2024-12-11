extends Area2D


@export var clue_name: String

@onready var sprite = $Sprite
@onready var collision = $Collision


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	sprite.hide()
	

func reveal_clue():
	sprite.show()
	collision.queue_free()
