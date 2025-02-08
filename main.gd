@tool
extends Node3D

const GROUND_TILE = preload("res://tiles/ground_tile/ground_tile.tscn")
const BOUNDARY_TILE = preload("res://tiles/boundary_tile.tscn")
const STAIRS = preload("res://tiles/stairs/stairs.tscn")
const FINISH_TILE = preload("res://tiles/finish_tile/finish_tile.tscn")
const TILE_SELECTOR = preload("res://tile_selector.tscn")

@export var p1_controls: PlayerControls
@export var p2_controls: PlayerControls
@export var controler_sens: float = 0.1
@export var map_size : Vector3i = Vector3i(4, 4, 4)
@export var tile_size : float = 5.0
@export var tile_height : float = 2.5

var grid = {}
var tile_selector = TILE_SELECTOR.instantiate()
var tile_selector_pos = Vector2(0, 0)
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
			if Global.player1:
				tile_selector_pos += Input.get_vector(p1_controls.left, p1_controls.right, p1_controls.up, p1_controls.down)
			else:
				tile_selector_pos += Input.get_vector(p2_controls.left, p2_controls.right, p2_controls.up, p2_controls.down) * controler_sens
				
			tile_selector_pos.x = snapped(clamp(tile_selector_pos.x, 0, map_size.x-1), 1)
			tile_selector_pos.y = snapped(clamp(tile_selector_pos.y, 0, map_size.y-1), 1)
			print(tile_selector_pos)
			tile_selector.global_position = tilemap_to_global(tile_selector_pos, tile_selector_lvl)
			
func generate_grid():
	for i in range(-1, map_size.x+1):
		for j in range(-1, map_size.y+1):
			
			if(i in range(map_size.x) and j in range(map_size.y)):
				generate_tile(i, j)
			else:
				generate_boundary_tile(i, j)

func generate_tile(x: int, y: int):
	var tile =  GROUND_TILE.instantiate()
	add_child(tile, true)		
	tile.global_position = tilemap_to_global(Vector2i(x, y))
	grid[tile.global_position] = tile
	
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
	print("STARTED")
	
func end_building_phase():
	Global.building_phase = false
	remove_child(tile_selector)
