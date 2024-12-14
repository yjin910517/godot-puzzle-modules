extends Area2D


enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}

var direction


func _ready() -> void:
	pass


func get_direction():
	return direction


func set_direction(new_dir):
	direction = new_dir	
	

# tile always rotate in clockwise, move the sensor to the next direction 
func rotate_direction():
	direction += 1
	if direction > 3:
		direction = 0
