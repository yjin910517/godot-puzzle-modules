extends Control

# tile specific config
@export var start_direction: int = 0
@export var tile_coordinate: Vector2

@onready var wire_connect = $WireConnect

var connected_neighbors: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wire_connect.set_direction(start_direction)
	rotation_degrees = start_direction * 90
	

# for initial level data load
func set_tile_data(tile_data):

	start_direction = tile_data["direction"]
	wire_connect.set_direction(start_direction)
	
	rotation_degrees = start_direction * 90
	
	tile_coordinate.x = tile_data["coordinate_x"]
	tile_coordinate.y = tile_data["coordinate_y"]
	
	
# for level data export
func get_tile_data():
	
	var tile_data = {
		"direction": start_direction,
		"coordinate_x": tile_coordinate.x,
		"coordinate_y": tile_coordinate.y
	}
	
	return tile_data
	
	
func update_neighbors():
	connected_neighbors = []
	if len(wire_connect.get_overlapping_areas()) > 0:
		var dir = wire_connect.get_direction()
		var neighbor_coord = _map_neighbor_node(dir)
		connected_neighbors.append(neighbor_coord)


func _map_neighbor_node(direction):
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
