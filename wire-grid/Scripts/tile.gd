extends Control


signal rotation_completed(tile)


# tile specific config
@export var tile_coordinate: Vector2
@export var tile_type: String

@onready var tile_display = $TileBG
@onready var wire_connect_group = $WireConnects

var wire_connects # iterators of wire end nodes
var is_rotating: bool
var connected_neighbors: Array  # array of connected direction enums
var is_powered: bool


func _ready() -> void:
	
	connect("gui_input", Callable(self, "_on_tile_gui_input"))
	is_rotating = false
	
	# initialize wire parameters
	wire_connects = wire_connect_group.get_children()
	if len(wire_connects) == 2:
		tile_type = "two"
	if len(wire_connects) == 3:
		tile_type = "three"
	if len(wire_connects) == 4:
		tile_type = "four"
	
	# initialize wire connects directions
	var idx = 0
	for connect_end in wire_connects:
		connect_end.set_direction(idx)
		idx += 1


# for level data load
func set_tile_data(tile_data):
	tile_type = tile_data["type"]
	rotation_degrees = tile_data["rotation"]
	tile_coordinate.x = tile_data["coordinate_x"]
	tile_coordinate.y = tile_data["coordinate_y"]
	
	# rotate the wire connectors to the desired state according to tile rotation
	var num_rotations = int(rotation_degrees / 90)
	for r in range(num_rotations):
		for connect_end in wire_connects:
				connect_end.rotate_direction()
				

# save game data
func get_tile_data():
	
	var tile_data = {
		"type": tile_type,
		"rotation": int(rotation_degrees) % 360,
		"coordinate_x": tile_coordinate.x,
		"coordinate_y": tile_coordinate.y
	}
	
	return tile_data
	
	
func update_neighbors():
	connected_neighbors = []
	for connect_end in wire_connects:
		if len(connect_end.get_overlapping_areas()) > 0:
			var dir = connect_end.get_direction()
			var neighbor_coord = map_neighbor_node(dir)
			connected_neighbors.append(neighbor_coord)


func power_up_wire():
	tile_display.frame = 1
	is_powered = true
	
	
func power_off_wire():
	tile_display.frame = 0
	is_powered = false
	

func map_neighbor_node(direction):
	var neighbor_coord
	if direction == 0:
		neighbor_coord = tile_coordinate + Vector2(-1,0)
	elif direction == 1:
		neighbor_coord = tile_coordinate + Vector2(0,1)		
	elif direction == 2:
		neighbor_coord = tile_coordinate + Vector2(1,0)		
	elif direction == 3:
		neighbor_coord = tile_coordinate + Vector2(0,-1)		
		
	return neighbor_coord
	

func get_neighbors():
	return connected_neighbors


# rotate tile when being left clicked
func _on_tile_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_rotating == false:
			var new_rotation = rotation_degrees + 90
			var tween = create_tween()
			
			# freeze mouse input while rotating
			is_rotating = true
			tween.tween_property(self, "rotation_degrees", new_rotation, 0.6)

			# update wire connection detectors to the new directions
			for connect_end in wire_connects:
				connect_end.rotate_direction()
					
			# resume mouse click detection after rotation completed
			tween.finished.connect(Callable(self, "_on_rotation_completed"))
		
			
func _on_rotation_completed():
	is_rotating = false
	emit_signal("rotation_completed", self)
