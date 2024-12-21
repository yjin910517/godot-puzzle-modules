extends Control


const TILE_SIZE = 128

var start
@onready var tiles = $Tiles
@onready var ends = $EndNodes
@onready var save_btn = $SaveButton

var mission_success: bool
var tile_matrix: Array

# tile scenes
var StartScene = load("res://Scenes/GridStart.tscn")
var EndScene = load("res://Scenes/GridEnd.tscn")
var TileScenes = {
	"two": load("res://Scenes/Tile2End.tscn"),
	"three": load("res://Scenes/Tile3End.tscn"),
	"four": load("res://Scenes/Tile4End.tscn"),
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# connect to data i/o buttons
	save_btn.connect("pressed", Callable(self, "_save_grid_data"))
	
	# generate empty grid array to hold tiles
	var row = []
	for i in range(TILE_SIZE):
		row.append(null)
		
	for j in range(TILE_SIZE):
		tile_matrix.append(row.duplicate())
	
	_load_grid_data()
	
	# to fix: on start, the grid doesn't light up the already connected tiles
	_check_grid_neighbors()
	_update_connected_route()

# initiate the level
func _load_grid_data():
	
	# load level data from saved file
	if not FileAccess.file_exists("res://LevelData/level1.save"):
		print("no level data found")
		return # Error! We don't have a save to load.
		
	var save_file = FileAccess.open("res://LevelData/level1.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	var tile_dataset = json.data
	
	# create start tile node
	start = StartScene.instantiate()
	add_child(start)
	start.set_tile_data(tile_dataset["start"])
	_place_tile_to_grid(start)
	
	# create wire tiles
	for node_data in tile_dataset["tiles"]:
		var tile_type = node_data["type"]
		var tile_node = TileScenes[tile_type].instantiate()
		tiles.add_child(tile_node)
		tile_node.connect("rotation_completed", Callable(self, "_on_tile_rotated"))
		tile_node.set_tile_data(node_data)
		_place_tile_to_grid(tile_node)

	# create end tile nodes
	for node_data in tile_dataset["ends"]:
		var end_node = EndScene.instantiate()
		ends.add_child(end_node)
		end_node.set_tile_data(node_data)
		_place_tile_to_grid(end_node)
	

func _place_tile_to_grid(tile_node):
	tile_node.size = Vector2(TILE_SIZE, TILE_SIZE)
	tile_node.pivot_offset = start.size/2
	
	var tile_x
	var tile_y

	tile_x = tile_node.tile_coordinate.x
	tile_y = tile_node.tile_coordinate.y
	tile_matrix[tile_x][tile_y] = tile_node
	tile_node.position = Vector2(tile_y * TILE_SIZE, tile_x * TILE_SIZE) # transposed axis
	

# save grid tiles status data 
func _save_grid_data():
	var start_data = start.get_tile_data()

	var tile_data = []
	var tile_nodes = tiles.get_children()
	for tile in tile_nodes:
		tile_data.append(tile.get_tile_data())
		
	var end_data = []
	var end_nodes = ends.get_children()
	for end in end_nodes:
		end_data.append(end.get_tile_data())
	
	var dataset = {
		"start": start_data,
		"tiles": tile_data,
		"ends": end_data
	}
	
	# export game data to data file
	var save_file = FileAccess.open("res://LevelData/level1.save", FileAccess.WRITE)
	var json_string = JSON.stringify(dataset)
	save_file.store_line(json_string)
	print("level data saved!")


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
