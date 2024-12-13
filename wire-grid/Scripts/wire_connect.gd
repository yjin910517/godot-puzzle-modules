extends Area2D


signal add_connection(direction)
signal remove_connection(direction)


enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}

var direction


func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))


func update_direction():
	direction += 1
	if direction > 3:
		direction = 0


func _on_area_entered(area):
	emit_signal("add_connection", direction)


func _on_area_exited(area):
	emit_signal("remove_connection", direction)
