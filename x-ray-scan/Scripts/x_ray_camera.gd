extends Area2D


signal hotspot_discovered(hotspot)
signal hotspot_ignored(hotspot)


@onready var anime = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))


func _on_area_entered(area):
	anime.play("positive")
	emit_signal("hotspot_discovered", area)


func _on_area_exited(area):
	anime.play("RESET")
	emit_signal("hotspot_ignored", area)
