extends Tile

var has_obstacle: bool = false

func _ready() -> void:
	has_obstacle = false
	var p = randf()
	if p < 0.3:
		has_obstacle = true
		var ind = randi_range(0, 5)
		p = randf()
		get_children()[ind].global_rotation.y += p*100
		get_children()[ind].visible = true
	for c in get_children():
		if not c.visible: c.queue_free()
