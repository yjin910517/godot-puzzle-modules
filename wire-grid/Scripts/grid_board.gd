extends Control


const TILE_SIZE = 128

@onready var tiles = $Tiles
@onready var start = $Start
@onready var ends = $EndNodes

var mission_success: bool

# empty grid matrix
var tile_matrix: Array = [
	[null, null, null, null], 
	[null, null, null, null], 
	[null, null, null, null], 
	[null, null, null, null], 
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var tile_x
	var tile_y
	
	var tile_nodes = tiles.get_children()
	for tile in tile_nodes:
		tile.connect("rotation_completed", Callable(self, "_on_tile_rotated"))
		
		# fill each tile into the right location in tile_matrix
		tile.size = Vector2(TILE_SIZE, TILE_SIZE)
		tile.pivot_offset = tile.size/2
		tile_x = tile.tile_coordinate.x
		tile_y = tile.tile_coordinate.y
		tile_matrix[tile_x][tile_y] = tile
		tile.position = Vector2(tile_y * TILE_SIZE, tile_x * TILE_SIZE) # transposed axis
	
	# fill in start tile
	start.size = Vector2(TILE_SIZE, TILE_SIZE)
	start.pivot_offset = start.size/2
	tile_x = start.tile_coordinate.x
	tile_y = start.tile_coordinate.y
	tile_matrix[tile_x][tile_y] = start
	start.position = Vector2(tile_y * TILE_SIZE, tile_x * TILE_SIZE) # transposed axis

	# fill in all target tiles
	var end_nodes = ends.get_children()
	for end in end_nodes:
		end.size = Vector2(TILE_SIZE, TILE_SIZE)
		end.pivot_offset = end.size/2
		tile_x = end.tile_coordinate.x
		tile_y = end.tile_coordinate.y
		tile_matrix[tile_x][tile_y] = end
		end.position = Vector2(tile_y * TILE_SIZE, tile_x * TILE_SIZE) # transposed axis
	
	# on start, the grid doesn't light up the already connected tiles

func _on_tile_rotated(rotated_tile):
	
	# check wire sensor overlaps and update each tile's connected neighbors
	_check_grid_neighbors()
	
	# traverse the routes with updated tile status
	_update_connected_route()


func _check_grid_neighbors():
	# update connected neighbors of each tile
	start.update_neighbors()
	
	var tile_nodes = tiles.get_children()
	
	for tile in tile_nodes:
		tile.update_neighbors()
			
	
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
		if current.get_parent() == ends:
			pass
		else:
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
	
	# check end targets status
	mission_success = true
	var end_nodes = ends.get_children()
	for end in end_nodes:
		if end not in visited:
			mission_success = false
			end.power_off_wire()
	
	if mission_success:
		print("puzzle solved")
