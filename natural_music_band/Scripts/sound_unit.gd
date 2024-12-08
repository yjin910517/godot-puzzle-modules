extends Node2D


@onready var sprite = $Sprite
@onready var sound = $Sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func sing():
	sprite.play("sing")
	sound.play()
