extends Control


@onready var tiles = $Tiles
@onready var start = $Start

# empty grid matrix
var tile_matrix: Array = [
	[null, null, null, null], 
	[null, null, null, null], 
	[null, null, null, null], 
	[null, null, null, null], 
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_nodes = tiles.get_children()
	var tile_x
	var tile_y
	for tile in tile_nodes:
		tile.connect("rotation_completed", Callable(self, "_on_tile_rotated"))
		
		# fill each tile into the right location in tile_matrix
		tile_x = tile.tile_coordinate.x
		tile_y = tile.tile_coordinate.y
		tile_matrix[tile_x][tile_y] = tile
	
	tile_x = start.tile_coordinate.x
	tile_y = start.tile_coordinate.y
	tile_matrix[tile_x][tile_y] = start


func _on_tile_rotated(rotated_tile):
	
	# update connected neighbors of each tile
	var tile_nodes = tiles.get_children()
	
	for tile in tile_nodes:
		tile.update_neighbors()
	
	start.update_neighbors()
	
	# traverse the routes with updated tile status
	_update_connected_route()
	
	
func _update_connected_route():
	var visited = {}
	var stack = [start]
	
	# traverse all connected routes start from power source
	while stack.size() > 0:
		var current = stack.pop_back()
		
		if current in visited:
			pass
		else:
			visited[current] = true
			
		# update connected neighbors
		var neighbor_coords = current.get_neighbors()
		for coord in neighbor_coords:
			var neighbor = tile_matrix[coord.x][coord.y]
			if neighbor not in visited:
				stack.append(neighbor)
				neighbor.power_up_wire()
	
	# reset tiles that are not connected
	var tile_nodes = tiles.get_children()
	for tile in tile_nodes:
		if tile not in visited:
			tile.power_off_wire()
