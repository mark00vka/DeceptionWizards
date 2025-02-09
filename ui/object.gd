extends TextureRect

signal player1_picked_tile(tile : PackedScene)
signal player2_picked_tile(tile : PackedScene)

@export var tile : TileResource

func set_pos(x, y):
	anchor_left = x
	anchor_top = y
	texture = tile.sprite
