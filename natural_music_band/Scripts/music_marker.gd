extends Area2D


signal note_hit()


@onready var icon = $Sprite

var texture_dataset = {
	"frog": load("res://Arts/music_mark_frog.png"),
	"goose": load("res://Arts/music_mark_goose.png"),
	"lizard": load("res://Arts/music_mark_lizard.png"),
	
}

var marker_name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))


func set_marker_connection(name, response_node):
	marker_name = name
	icon.texture = texture_dataset[marker_name]
	connect("note_hit", Callable(response_node, "sing"))
	

func _on_area_entered(area):
	emit_signal("note_hit")
