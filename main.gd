extends Node3D

const TILE = preload("res://tile.tscn")

@export var map_size : Vector2
@export var tile_size : float = 5.0

func _ready() -> void:
	for i in range(map_size.x):
		for j in range(map_size.x):
			var tile =  TILE.instantiate()
			tile.global_position = Vector3(i, 0, j) * tile_size
			add_child(tile)
