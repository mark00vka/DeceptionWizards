extends Control

func _on_global_change_phase() -> void:
	if Global.is_building_phase():
		var tween = get_tree().create_tween()
		for c in [$VBoxContainer/Q, $VBoxContainer/E, $VBoxContainer/K, $VBoxContainer/L, $VBoxContainer/R, $VBoxContainer2/O, $VBoxContainer2/S, $VBoxContainer2/T, $VBoxContainer2/L2, $VBoxContainer2/R2]:
			c.show()
			c.scale = Vector2(0.1, 0.1)
			tween.chain().tween_property(c, "scale", Vector2(1.0, 1.0), 0.1)
	else:
		for c in [$VBoxContainer/Q, $VBoxContainer/E, $VBoxContainer/K, $VBoxContainer/L, $VBoxContainer/R, $VBoxContainer2/O, $VBoxContainer2/S, $VBoxContainer2/T, $VBoxContainer2/L2, $VBoxContainer2/R2]:
			c.hide()
