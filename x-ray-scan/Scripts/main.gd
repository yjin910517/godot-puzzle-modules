extends Control


@onready var magnify_glass = $MagnifyGlass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide system cursor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# magnify glass icon follows mouse cursor
	magnify_glass.global_position = get_global_mouse_position()
