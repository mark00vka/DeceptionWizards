@tool
extends Node3D

const TILE = preload("res://tiles/base_tile/tile.tscn")
const BOUNDARY_TILE = preload("res://boundary_tile.tscn")
const STAIRS = preload("res://tiles/stairs/stairs.tscn")

@export var map_size : Vector3i = Vector3i(4, 4, 4)
@export var tile_size : float = 5.0
@export var tile_height : float = 2.5
 
func tilemap_to_global(pos: Vector2i, level : int = 0):
	return Vector3(pos.x, 0, pos.y) * tile_size + Vector3.UP * level * tile_height

func _ready() -> void:
	generate_grid()
	place_item(STAIRS, Vector2i(0, 1),  0, 1)
	
func generate_grid():
	for i in range(map_size.x):
		for j in range(map_size.y):
			var tile =  TILE.instantiate()
			add_child(tile)
			tile.global_position = tilemap_to_global(Vector2i(i, j))

func place_item(item : PackedScene, pos : Vector2i, level : int, rot: int = 0):
	var inst = item.instantiate()
	add_child(inst)
	inst.global_position = tilemap_to_global(pos, level)
	inst.global_rotation.y = rot * PI / 2
