extends Area2D


signal clue_discovered(clue)
signal clue_ignored(clue)


@onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))


func _on_area_entered(area):
	sprite.play("positive")
	emit_signal("clue_discovered", area)


func _on_area_exited(area):
	sprite.stop()
	emit_signal("clue_ignored", area)
