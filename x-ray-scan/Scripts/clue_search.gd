extends Control


@onready var magnify_glass = $MagnifyGlass

var focused_clue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide system cursor
	magnify_glass.connect("clue_discovered", Callable(self, "_on_clue_discovered"))
	magnify_glass.connect("clue_ignored", Callable(self, "_on_clue_ignored"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# magnify glass icon follows mouse cursor
	magnify_glass.global_position = get_global_mouse_position()
	
	if focused_clue:
		if Input.is_action_just_pressed("detect"):
			focused_clue.reveal_clue()


func _on_clue_discovered(clue_node):
	focused_clue = clue_node
	

func _on_clue_ignored(clue_node):
	if focused_clue == clue_node:
		focused_clue = null
