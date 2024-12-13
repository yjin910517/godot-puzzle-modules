extends Control


signal rotated(tile)

@onready var connect1 = $WireConnect1
@onready var connect2 = $WireConnect2


var is_rotating: bool
var connections: Dictionary


# test data
var connections_init = {
	0: false, # up
	1: false, # right
	2: false, # down
	3: false, # left
}

var directions_init = [0, 1]


func _ready() -> void:
	
	# set up wire connection detectors
	connect1.connect("add_connection", Callable(self, "_on_add_connection"))
	connect1.connect("remove_connection", Callable(self, "_on_remove_connection"))

	connect2.connect("add_connection", Callable(self, "_on_add_connection"))
	connect2.connect("remove_connection", Callable(self, "_on_remove_connection"))
	
	connect("gui_input", Callable(self, "_on_tile_gui_input"))
	is_rotating = false
	
	load_connections(connections_init)
	load_directions(directions_init )


# for initial level data load
func load_connections(new_connections):
	connections = new_connections


# for initial level data load
func load_directions(new_directions: Array):
	connect1.direction = new_directions[0]
	connect2.direction = new_directions[1]
		

func _on_add_connection(direction):
	if connections.has(direction):
		connections[direction] = true


func _on_remove_connection(direction):
	if connections.has(direction):
		# when the tile is rotating and leaving an old neighbor
		if is_rotating:
			var old_direction = direction - 1
			if old_direction < 0:
				old_direction = 3
			connections[old_direction] = false
		# when the neighbor is leaving
		else:
			connections[direction] = false

		
# rotate tile when being left clicked
func _on_tile_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_rotating == false:
			var new_rotation = rotation_degrees + 90
			var tween = create_tween()
			
			# update wire connection detectors to the new directions
			connect1.update_direction()
			connect2.update_direction()
			
			# freeze mouse input while rotating
			is_rotating = true
			tween.tween_property(self, "rotation_degrees", new_rotation, 1)
			
			# resume mouse click detection after rotation completed
			tween.finished.connect(Callable(self, "_on_rotation_completed"))
			
			
func _on_rotation_completed():
	is_rotating = false
	emit_signal("rotated", self)
