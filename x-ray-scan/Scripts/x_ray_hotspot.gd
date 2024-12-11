extends Area2D

@export var hotspot_name: String

@onready var collision = $Collision


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	

func _on_area_entered(area):
	print("entered ", hotspot_name)
	
	
func _on_area_exited(area):
	print("left ", hotspot_name)


func resolve_hotspot():
	collision.queue_free()
