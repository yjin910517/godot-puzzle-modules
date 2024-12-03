extends Control

@onready var blueprint = $Blueprint
@onready var display = $Display
@onready var panel = $Panel

var target_shape
var target_size
var target_thick

var shape_idx
var size_idx
var thick_idx

var is_match

enum screen_display {BLUEPRINT, READY}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	blueprint.connect("ingest_blueprint", Callable(self, "_on_blueprint_ingested"))
	panel.connect("updated_egg_dimensions", Callable(self, "_on_updated_egg_dimensions"))
	panel.connect("clicked_go_button", Callable(self, "_on_clicked_go_button"))
	
	reset_machine()

	# test
	# _on_blueprint_ingested(2,2,1)


func reset_machine():
	is_match = false
	shape_idx = 0
	size_idx = 0
	thick_idx = 0
	
	blueprint.reset_blueprint()
	panel.reset_knobs()
	display.full_screen_display(screen_display.BLUEPRINT)


func _on_blueprint_ingested(bp_shape, bp_size, bp_thickness):
	target_shape = bp_shape
	target_size = bp_size
	target_thick = bp_thickness
	
	# to do: add a blueprint reading animation
	# to do: full screen display of reading
	# to do: trigger display below by completion of reading transition
	display.update_reference_display(target_shape, target_size, target_thick)
	display.update_egg_display(shape_idx, size_idx, thick_idx)
	display.start_compare_display()
	
	panel.activate_panel()
	

func _on_updated_egg_dimensions(selected_shape, selected_size, selected_thick):
	shape_idx = selected_shape
	size_idx = selected_size
	thick_idx = selected_thick

	if shape_idx == target_shape and size_idx == target_size and thick_idx == target_thick:
		is_match = true
		panel.activate_go_button()
	
	display.update_egg_display(shape_idx, size_idx, thick_idx)
	display.update_feedback(is_match)
	

func _on_clicked_go_button():
	display.full_screen_display(screen_display.READY)
