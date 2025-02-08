extends TextureRect

@export var sens: float = 1.0
@export var controls : PlayerControls

func _process(delta: float) -> void:
	var input := Input.get_vector(controls.left, controls.right, controls.fwd, controls.back)
	anchor_left += input.x * sens * delta
	anchor_left = clamp(anchor_left, 0, 1)
	anchor_right = anchor_left
	anchor_top += input.y * sens * delta
	anchor_top = clamp(anchor_top, 0, 1)
	anchor_bottom = anchor_top
	
