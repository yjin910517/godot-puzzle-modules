extends Control


signal rotation_completed(tile)


@onready var wire_connect_group = $WireConnects

var wire_connects # iterators of wire end nodes
var is_rotating: bool
var connected_neighbors: Array  # array of connected direction enums


# tile specific config
@export var directions_init = [0, 1]


func _ready() -> void:
	
	connect("gui_input", Callable(self, "_on_tile_gui_input"))
	is_rotating = false
	
	wire_connects = wire_connect_group.get_children()
	load_directions(directions_init)


# for initial level data load
func load_directions(new_directions: Array):
	var idx = 0
	for connect_end in wire_connects:
		connect_end.set_direction(new_directions[idx])
		idx += 1
		

func update_neighbors():
	connected_neighbors = []
	for connect_end in wire_connects:
		if len(connect_end.get_overlapping_areas()) > 0:
			connected_neighbors.append(connect_end.get_direction())

		
# rotate tile when being left clicked
func _on_tile_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_rotating == false:
			var new_rotation = rotation_degrees + 90
			var tween = create_tween()
			
			# freeze mouse input while rotating
			is_rotating = true
			tween.tween_property(self, "rotation_degrees", new_rotation, 1)

			# update wire connection detectors to the new directions
			for connect_end in wire_connects:
				connect_end.rotate_direction()
					
			# resume mouse click detection after rotation completed
			tween.finished.connect(Callable(self, "_on_rotation_completed"))
		
			
func _on_rotation_completed():
	is_rotating = false
	emit_signal("rotation_completed", self)
