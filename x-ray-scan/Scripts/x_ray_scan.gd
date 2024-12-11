extends Control


@onready var cover = $Cover
@onready var camera = $Camera
@onready var camera_ui = $Camera/XrayWindow
@onready var camera_content = $Camera/XrayView/Content

var focused_hotspot


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide system cursor
		camera_ui.connect("hotspot_discovered", Callable(self, "_on_hotspot_discovered"))
		camera_ui.connect("hotspot_ignored", Callable(self, "_on_hotspot_ignored"))


func _process(delta: float) -> void:
	# x-ray window follows mouse cursor
	camera.global_position = get_global_mouse_position()
	# x-ray display maintain constant global position
	camera_content.position = (camera.global_position - cover.global_position) * -1
	

func _on_hotspot_discovered(hotspot):
	focused_hotspot = hotspot


func _on_hotspot_ignored(hotspot):
	if focused_hotspot == hotspot:
		focused_hotspot = null
