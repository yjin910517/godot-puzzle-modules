extends Control


@onready var full_screen = $FullScreen
@onready var reference = $Reference
@onready var selected_egg = $Selection
@onready var feedback = $Feedback
@onready var anime = $AnimationPlayer


const shell_path = "res://Arts/shell_icons/"

var blueprint_text = preload("res://Arts/insert_blueprint_text.png")
var match_text = preload("res://Arts/match_text.png")
var not_match_text = preload("res://Arts/not_match_text.png")
var completed_text = preload("res://Arts/ready_text.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func start_compare_display():
	feedback.texture = null
	reference.show()
	selected_egg.show()
	feedback.show()
	full_screen.hide()


func full_screen_display(display_idx):
	reference.hide()
	selected_egg.hide()
	feedback.hide()
		
	# insert blueprint
	if display_idx == 0:
		full_screen.texture = blueprint_text 
		
	# job ready
	if display_idx == 1:
		full_screen.texture = completed_text
	
	full_screen.show()
		
		
func update_reference_display(target_shape, target_size, target_thick):
	var ref_path = shell_path + str(target_shape) + "_" + str(target_size) + "_" + str(target_thick) + ".png"
	reference.texture = load(ref_path)


func update_egg_display(shape_idx, size_idx, thick_idx):
	# update displayed selection
	var selected_path = shell_path + str(shape_idx) + "_" + str(size_idx) + "_" + str(thick_idx) + "_light.png"
	selected_egg.texture = load(selected_path)
	

func update_feedback(is_match):
	if is_match:
		feedback.texture = match_text
		
	else:
		feedback.texture = not_match_text
		anime.play("not_match")
