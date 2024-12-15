extends Control

# tile specific config
@export var start_direction: int = 0
@export var tile_coordinate: Vector2

@onready var wire_connect = $WireConnect

var connected_neighbors: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# point up
	load_start_direction(start_direction)


# for initial level data load
func load_start_direction(init_direction):
	wire_connect.set_direction(init_direction)
	rotation_degrees = init_direction * 90


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
