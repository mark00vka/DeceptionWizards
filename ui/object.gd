extends TextureRect

@export var tile : TileResource

var select : bool = false

func set_pos(x, y):
	anchor_left = x
	anchor_top = y
	texture = tile.sprite
	scale = Vector2(0.1,0.1)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_CUBIC)
	
