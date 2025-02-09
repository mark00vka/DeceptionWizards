extends TextureRect

@export var tile : TileResource

func set_pos(x, y):
	anchor_left = x
	anchor_top = y
	texture = tile.sprite
		
