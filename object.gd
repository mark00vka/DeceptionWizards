extends TextureRect

@export var tile : TileResource

func _ready() -> void:
	anchor_left = randf() * 0.75
	anchor_top = randf() * 0.75
	texture = tile.sprite
