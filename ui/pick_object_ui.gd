extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel
@onready var object_holder: Control = $Panel/ObjectHolder
@onready var stairs: TextureRect = $Panel/ObjectHolder/Stairs
@onready var wall: TextureRect = $Panel/ObjectHolder/Wall
@onready var platform: TextureRect = $Panel/ObjectHolder/Platform

var x_pull : Array[float] = [0.0, 0.15, 0.3, 0.4, 0.45, 0.6, 0.65, 0.75]
var y_pull : Array[float] = [0.0, 0.1, 0.15, 0.3, 0.4, 0.45, 0.6, 0.75]

func show_ui():
	show()
	var tween = get_tree().create_tween()
	color_rect.modulate.a = 0
	panel.position.y = 900
	tween.parallel().tween_property(color_rect, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(panel, "position:y", 38, 1.0).set_trans(Tween.TRANS_CUBIC)
	for i in range(randi() % 3 + 6):
		var inst
		var t = randf()
		if t < 0.5:
			inst = stairs.duplicate()
		elif t < 0.75:
			inst = wall.duplicate()
		else:
			inst = platform.duplicate()
		object_holder.add_child(inst)
		inst.show()
		
		var x = x_pull.pick_random()
		x_pull.erase(x)
		var y = y_pull.pick_random()
		y_pull.erase(y)
		inst.set_pos(x, y)

	#stairs.queue_free()
	#wall.queue_free()
	#platform.queue_free()
