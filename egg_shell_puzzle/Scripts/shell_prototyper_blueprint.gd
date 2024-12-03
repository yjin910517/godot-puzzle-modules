extends Control


signal ingest_blueprint(bp_shape, bp_size, bp_thick)


var is_reacting


func _ready() -> void:
	pass


func reset_blueprint():
	is_reacting = true
	# to do reset visual change


# specify behavior when being dropped on
func _can_drop_data(position, data):
	if is_reacting == false:
		return false
	return data.has("blueprint")


func _drop_data(position, data):
	
	_occupy_slot()
	
	var blueprint_icon = data["blueprint"]
	var blueprint_data = blueprint_icon.get_blueprint_data()
	var bp_shape = blueprint_data["shape"]
	var bp_size = blueprint_data["size"]
	var bp_thick = blueprint_data["thickness"]
	
	emit_signal("ingest_blueprint", bp_shape, bp_size, bp_thick)
	blueprint_icon.queue_free()


func _occupy_slot():
	is_reacting = false
	# to do: add visual change
