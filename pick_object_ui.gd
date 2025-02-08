extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel

func show_ui():
	show()
	var tween = get_tree().create_tween()
	color_rect.modulate.a = 0
	panel.position.y = 900
	tween.parallel().tween_property(color_rect, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(panel, "position:y", 38, 1.0).set_trans(Tween.TRANS_CUBIC)
