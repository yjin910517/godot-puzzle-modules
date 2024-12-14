extends Control


@onready var tiles = $Tiles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_nodes = tiles.get_children()
	
	for tile in tile_nodes:
		tile.connect("rotation_completed", Callable(self, "_on_tile_rotated"))


func _on_tile_rotated(rotated_tile):
	var tile_nodes = tiles.get_children()
	
	for tile in tile_nodes:
		tile.update_neighbors()
		
		print(tile.name, ": ", tile.connected_neighbors)
		
	# to do: add route traverse logic and run here
