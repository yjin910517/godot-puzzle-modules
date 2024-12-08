extends Area2D


@onready var sound = $Sound
@onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))


func _on_area_entered(area):
	sound.play()
	sprite.play("default")
