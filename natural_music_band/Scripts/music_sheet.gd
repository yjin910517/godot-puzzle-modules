extends Control


@onready var music_roll = $MusicRoll

var node_pairing

var MarkerScene = preload("res://Scenes/MusicMarker.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func initiate_sheet(nodes_dict):
	node_pairing = nodes_dict


func start_recording():
	music_roll.play_rolling()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var current_input
	var pos_x
	
	if Input.is_action_just_pressed("frog"):
		current_input = "frog"
		pos_x = music_roll.get_ticker_x()
		add_music_marker(current_input, pos_x)
		
	if Input.is_action_just_pressed("goose"):
		current_input = "goose"
		pos_x = music_roll.get_ticker_x()
		add_music_marker(current_input, pos_x)

	if Input.is_action_just_pressed("lizard"):
		current_input = "lizard"
		pos_x = music_roll.get_ticker_x()
		add_music_marker(current_input, pos_x)

func add_music_marker(marker_name, pos_x):
	
	print(marker_name, " input at ", pos_x)
	
	var new_marker = MarkerScene.instantiate()
	add_child(new_marker)
	
	var pos_y = node_pairing[marker_name]["y"]
	var paired_node = node_pairing[marker_name]["node"]
	paired_node.sing()
	new_marker.position = Vector2(pos_x, pos_y)
	new_marker.set_marker_connection(marker_name, paired_node)
	new_marker.show()
