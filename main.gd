@tool
extends Node3D

const GROUND_TILE = preload("res://tiles/ground_tile/ground_tile.tscn")
const BOUNDARY_TILE = preload("res://tiles/boundary_tile.tscn")
const STAIRS = preload("res://tiles/stairs/stairs.tscn")
const FINISH_TILE = preload("res://tiles/finish_tile/finish_tile.tscn")
const TILE_SELECTOR = preload("res://tile_selector.tscn")

@export var map_size : Vector3i = Vector3i(4, 4, 4)
@export var tile_size : float = 5.0
@export var tile_height : float = 2.5

var grid: Array[Array] = []
var row: Array[Tile] = []
var tile_selector = TILE_SELECTOR.instantiate()
var tile_selector_pos = Vector2i(0, 0)
var tile_selector_lvl: int = 0
 
func tilemap_to_global(pos: Vector2i, level : int = 0):
	return Vector3(pos.x, 0, pos.y) * tile_size + Vector3.UP * level * tile_height

func _ready() -> void:
	generate_grid()
	place_item(STAIRS, Vector2i(0, 1),  0, 1)
	place_item(FINISH_TILE, Vector2i(0, 0),  1, 0)
	start_building_phase()
	
func _input(event: InputEvent) -> void:
		if Global.building_phase:
			if event.is_action_pressed("forward"):
				if(tile_selector_pos.y-1) in  range(map_size.y): tile_selector_pos += Vector2i(0, -1)
			if event.is_action_pressed("back"):
				if(tile_selector_pos.y+1) in  range(map_size.y): tile_selector_pos += Vector2i(0, 1)
			if event.is_action_pressed("right"):
				if(tile_selector_pos.x+1) in  range(map_size.x): tile_selector_pos += Vector2i(1, 0)
			if event.is_action_pressed("left"):
				if(tile_selector_pos.x-1) in  range(map_size.x): tile_selector_pos += Vector2i(-1, 0)
			tile_selector.global_position = tilemap_to_global(tile_selector_pos, tile_selector_lvl)
			
				
	
func generate_grid():

	for i in range(-1, map_size.x+1):
		for j in range(-1, map_size.y+1):
			
			if(i in range(map_size.x) and j in range(map_size.y)):
				generate_tile(i, j)
			else:
				generate_boundary_tile(i, j)
		if i in range(map_size.x): grid.append(row)
	print(grid)

func generate_tile(x: int, y: int):
	var tile =  GROUND_TILE.instantiate()
	add_child(tile, true)		
	tile.global_position = tilemap_to_global(Vector2i(x, y))
	row.append(tile)
	
func generate_boundary_tile(x: int, y: int):
	var boundary_tile =  BOUNDARY_TILE.instantiate()
	add_child(boundary_tile, true)		
	boundary_tile.global_position = tilemap_to_global(Vector2i(x, y))

func place_item(item : PackedScene, pos : Vector2i, level : int, rot: int = 0):
	var inst = item.instantiate()
	add_child(inst, true)
	inst.global_position = tilemap_to_global(pos, level)
	inst.global_rotation.y = rot * PI / 2

func start_building_phase():
	Global.building_phase = true
	add_child(tile_selector, true)
	tile_selector.global_position = tilemap_to_global(Vector2i(0,0))
	
func end_building_phase():
	Global.building_phase = false
	remove_child(tile_selector)
