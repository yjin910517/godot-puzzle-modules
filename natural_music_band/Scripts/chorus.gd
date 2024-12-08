extends Control

@onready var music_sheet = $MusicSheet

@onready var frog = $Frog
@onready var goose = $Goose
@onready var lizard = $Lizard

var nodes_dict


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	nodes_dict = {
		"frog": {"y": 80, "node": frog},
		"lizard": {"y": 160, "node": lizard},
		"goose": {"y": 240, "node": goose}
	}

	music_sheet.initiate_sheet(nodes_dict)
	music_sheet.start_recording()
