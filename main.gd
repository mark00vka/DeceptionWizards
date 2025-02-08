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
	
func _process(delta: float) -> void:
		if Global.building_phase:
			update_tile_selector_pos()
			if not selected_tile_free(tile_selector_pos, tile_selector_lvl): 
				#TODO: PROMENI BOJU
				pass

			tile_selector.global_position = tilemap_to_global(tile_selector_pos, tile_selector_lvl)

		
func selected_tile_free(tile_pos: Vector2i, tile_lvl: int) -> bool:
	return !grid.has(pos_lvl_to_vector3i(tile_pos, tile_lvl))
		
func get_player2_input():
	var move_dir = Vector2.ZERO
	if Input.is_action_just_pressed(p2_controls.fwd):
		move_dir = Vector2(0, -1)
	elif Input.is_action_just_pressed(p2_controls.back):
		move_dir = Vector2(0, 1)
	elif Input.is_action_just_pressed(p2_controls.left):
		move_dir = Vector2(-1, 0)
	elif Input.is_action_just_pressed(p2_controls.right):
		move_dir = Vector2(1, 0)
	return move_dir
		
func update_tile_selector_pos():
	#TODO: DODATI UP AND DOWN
	if Global.player1:
		tile_selector_pos += Input.get_vector(p1_controls.left, p1_controls.right, p1_controls.up, p1_controls.down)
	else:
		tile_selector_pos += get_player2_input()

	tile_selector_pos.x = clamp(tile_selector_pos.x, 0, map_size.x-1)
	tile_selector_pos.y = clamp(tile_selector_pos.y, 0, map_size.y-1)
			
func generate_grid():
	for i in range(-1, map_size.x+1):
		for j in range(-1, map_size.y+1):
			
			if(i in range(map_size.x) and j in range(map_size.y)):
				generate_tile(i, j)
			else:
				generate_boundary_tile(i, j)

func generate_tile(x: int, y: int):
	var ground_tile =  GROUND_TILE.instantiate()
	add_child(ground_tile, true)		
	ground_tile.global_position = tilemap_to_global(Vector2i(x, y))
	#grid[tile.global_position] = tile
	
func generate_boundary_tile(x: int, y: int):
	var boundary_tile =  BOUNDARY_TILE.instantiate()
	add_child(boundary_tile, true)		
	boundary_tile.global_position = tilemap_to_global(Vector2i(x, y))

func place_item(item : PackedScene, pos : Vector2i, level : int, rot: int = 0):
	var inst = item.instantiate()
	add_child(inst, true)
	inst.global_position = tilemap_to_global(pos, level)
	inst.global_rotation.y = rot * PI / 2
	grid[pos_lvl_to_vector3i(pos, level)] = inst

func start_building_phase():
	Global.building_phase = true
	add_child(tile_selector, true)
	tile_selector.global_position = tilemap_to_global(Vector2i(0,0))
	print("STARTED")
	
func end_building_phase():
	Global.building_phase = false
	remove_child(tile_selector)
	
func pos_lvl_to_vector3i(pos: Vector2i, lvl: int) -> Vector3i:
	return Vector3i(pos.x, lvl, pos.y)
