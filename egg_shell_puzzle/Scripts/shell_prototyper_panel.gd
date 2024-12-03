extends Control


signal updated_egg_dimensions(selected_shape, selected_size, selected_thick)
signal clicked_go_button()


@onready var shape_knob_ctr = $ShapeKnobControl
@onready var shape_knob = $ShapeKnobControl/ShapeKnob
@onready var size_knob_ctr = $SizeKnobControl
@onready var size_knob = $SizeKnobControl/SizeKnob
@onready var thick_ctr = $ThickControl
@onready var thickness_switch = $ThickControl/ThicknessSwitch

@onready var button_ctr = $ButtonControl
@onready var go_button = $ButtonControl/GoButton


var selected_shape
var selected_size
var selected_thick

var is_knob_reacting
var is_ready_to_go


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shape_knob_ctr.connect("gui_input", Callable(self, "_on_shape_gui_input"))
	size_knob_ctr.connect("gui_input", Callable(self, "_on_size_gui_input"))
	thick_ctr.connect("gui_input", Callable(self, "_on_thick_gui_input"))
	button_ctr.connect("gui_input", Callable(self, "_on_button_gui_input"))


func reset_knobs():
	is_knob_reacting = false
	
	selected_shape = 0
	shape_knob.frame = selected_shape
	selected_size = 0
	size_knob.frame = selected_size
	selected_thick = 0
	thickness_switch.frame = selected_thick
	
	is_ready_to_go = false
	go_button.play("inactive")
	

func activate_panel():
	is_knob_reacting = true
	

func activate_go_button():
	# freeze knobs
	is_knob_reacting = false
	
	# activate go button
	is_ready_to_go = true
	go_button.play("active")
	
	
func _on_shape_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_knob_reacting:
			# update selected shape 
			selected_shape += 1
			if selected_shape > 2: 
				selected_shape = 0
			shape_knob.frame = selected_shape
			
			emit_signal("updated_egg_dimensions", selected_shape, selected_size, selected_thick)


func _on_size_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_knob_reacting:
			# update selected size 
			selected_size += 1
			if selected_size > 2: 
				selected_size= 0
			size_knob.frame = selected_size
			
			emit_signal("updated_egg_dimensions", selected_shape, selected_size, selected_thick)


func _on_thick_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_knob_reacting:
			# update selected thickness 
			if selected_thick== 0:
				selected_thick = 1
			else:
				selected_thick = 0
			thickness_switch.frame = selected_thick
			
			emit_signal("updated_egg_dimensions", selected_shape, selected_size, selected_thick)


func _on_button_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_ready_to_go:
			is_ready_to_go = false
			go_button.play("inactive")
			
			emit_signal("clicked_go_button")
