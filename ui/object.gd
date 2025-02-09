extends TextureRect

signal player1_picked_tile(tile : Tile)
signal player2_picked_tile(tile : Tile)

@export var tile : TileResource

func set_pos(x, y):
	anchor_left = x
	anchor_top = y
	texture = tile.sprite

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputManager.p1_controls.jump):
		player1_picked_tile.emit(tile.tile)
	if event.is_action_pressed(InputManager.p2_controls.jump):
		player2_picked_tile.emit(tile.tile)
		
