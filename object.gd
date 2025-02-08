extends TextureRect

@export var tile : TileResource

func _ready() -> void:
	anchor_left = randf() * 0.75
	anchor_top = randf() * 0.75
	texture = tile.sprite


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed():
		
