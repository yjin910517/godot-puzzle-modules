extends Control


# tile specific config
@export var start_direction: int = 3
@export var tile_coordinate: Vector2

@onready var tile_display = $TileBG
@onready var wire_connect = $WireConnect

var is_powered: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# point left
	load_start_direction(start_direction)


# for initial level data load
func load_start_direction(init_direction):
	wire_connect.set_direction(init_direction)
	rotation_degrees = (init_direction - 3) * 90


func power_up_wire():
	tile_display.frame = 1
	is_powered = true
	
	
func power_off_wire():
	tile_display.frame = 0
	is_powered = false
