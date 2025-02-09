@tool

extends Node3D

const GROUND_TILE = preload("res://tiles/ground_tile/ground_tile.tscn")
const BOUNDARY_TILE = preload("res://tiles/boundary_tile/boundary_tile.tscn")
const FINISH_TILE = preload("res://tiles/finish_tile/finish_tile.tscn")

const STAIRS = preload("res://tiles/stairs/stairs.tscn")
const PLATFORM = preload("res://tiles/platform_tile/platform.tscn")
const WALL = preload("res://tiles/wall_tile/wall.tscn")

var BUILD_TILES = [STAIRS, PLATFORM, WALL]

const PLAYER = preload("res://player/player.tscn")

@export var map_size : Vector3i = Vector3i(4, 4, 4)
@export var tile_size : float = 5.0
@export var tile_height : float = 2.5

var grid : Dictionary = {}

func _ready() -> void:
	generate_grid()
	place_item(FINISH_TILE, Vector2i(0, 0),  1, 1)
	Global.starting_screen = true
	
func generate_grid():
	for i in range(-1, map_size.x+1):
		for j in range(-1, map_size.z+1):
			if(i in range(map_size.x) and j in range(map_size.z)):
				generate_tile(i, j)
				await get_tree().create_timer(0.1).timeout
			else:
				generate_boundary_tile(i, j)

func generate_tile(x: int, y: int):
	var ground_tile =  GROUND_TILE.instantiate()
	add_child(ground_tile, true)		
	ground_tile.global_position = tilemap_to_global(Vector2i(x, y))
	ground_tile.scale = Vector3(0.1,0.1,0.1)
	var tween = get_tree().create_tween()
	tween.tween_property(ground_tile, "scale", Vector3.ONE, 0.1).set_trans(Tween.TRANS_SINE)
	
	if ((x == 0 and y == 0) or (x == map_size.x-1 and y == map_size.z-1)) and ground_tile.has_obstacle:
		ground_tile.get_children()[0].queue_free()
		ground_tile.has_obstacle = false
		
	if ground_tile.has_obstacle:
		grid[Vector3i(x, 0, y)] = ground_tile
		
	if (x + y) % 2 == 0:
		ground_tile.get_node("MeshInstance3D").mesh.material.albedo_texture = preload("res://tiles/ground_tile/dark_ground.png")
	
func generate_boundary_tile(x: int, y: int):
	var boundary_tile =  BOUNDARY_TILE.instantiate()
	add_child(boundary_tile, true)		
	boundary_tile.global_position = tilemap_to_global(Vector2i(x, y))

func place_item(item : PackedScene, pos : Vector2i, level : int, real: bool = true, rot: int = 0):
	var inst : Tile = item.instantiate()
	add_child(inst, true)
	inst.global_position = tilemap_to_global(pos, level)
	inst.global_rotation.y = rot * PI / 2
	inst.real = real
	grid[pos_lvl_to_vector3(pos, level)] = inst
			
func tilemap_to_global(pos: Vector2i, level : int = 0):
	return Vector3(pos.x, 0, pos.y) * tile_size + Vector3.UP * level * tile_height
	
func global_to_tilemap(pos: Vector3):
	var pos1 = pos - Vector3.UP * pos.y * tile_height
	pos1 /= tile_size
	return Vector3i(pos1.x, pos1.y, pos1.z)

func selected_tile_free(tile_pos: Vector2i, tile_lvl: int) -> bool:
	return not grid.has(pos_lvl_to_vector3(tile_pos, tile_lvl))

func pos_lvl_to_vector3(pos: Vector2i, lvl: int) -> Vector3i:
	return Vector3(pos.x, lvl, pos.y)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/main.tscn")
