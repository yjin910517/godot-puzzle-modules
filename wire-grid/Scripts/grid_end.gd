extends Control


# tile specific config
@export var start_direction: int = 3
@export var tile_coordinate: Vector2

@onready var tile_display = $TileBG
@onready var wire_connect = $WireConnect

var is_powered: bool


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


func power_up_wire():
	tile_display.frame = 1
	is_powered = true
	
	
func power_off_wire():
	tile_display.frame = 0
	is_powered = false


func get_tile_data():
	
	var tile_data = {
		"direction": start_direction,
		"coordinate_x": tile_coordinate.x,
		"coordinate_y": tile_coordinate.y
	}
	
	return tile_data
