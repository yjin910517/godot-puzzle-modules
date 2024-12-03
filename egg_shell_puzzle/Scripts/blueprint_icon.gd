extends Control


@onready var icon = $Icon

@export var bp_shape: int
@export var bp_size: int
@export var bp_thick: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon.mouse_filter = MOUSE_FILTER_IGNORE
	# test
	# set_blueprint_data(2,1,1)


func set_blueprint_data(new_shape, new_size, new_thick):
	bp_shape = new_shape
	bp_size = new_size
	bp_thick = new_thick
	

func get_blueprint_data():
	var dataset = {"shape": bp_shape, "size": bp_size, "thickness": bp_thick}
	return dataset
	

# Specify behavior when being dragged
func _get_drag_data(event):
	print("blueprint getting dragged")
	var drag_data = {"blueprint": self}
	var preview = ColorRect.new()
	preview.color = icon.color
	preview.size = icon.size  # Use rect_size to set the size correctly
	preview.visible = true              # Ensure the preview is visible
	set_drag_preview(preview)
	return drag_data
