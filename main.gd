extends Node3D

const GROUND_TILE = preload("res://tiles/ground_tile/ground_tile.tscn")
const BOUNDARY_TILE = preload("res://tiles/boundary_tile.tscn")
const STAIRS = preload("res://tiles/stairs/stairs.tscn")
const FINISH_TILE = preload("res://tiles/finish_tile/finish_tile.tscn")
const TILE_SELECTOR = preload("res://tile-selector/tile_selector.tscn")

@export var map_size : Vector3i = Vector3i(4, 4, 4)
@export var tile_size : float = 5.0
@export var tile_height : float = 2.5

var grid = {}
var tile_selector = TILE_SELECTOR.instantiate()

func _ready() -> void:
	generate_grid()
	place_item(STAIRS, Vector2i(0, 1),  0, 1)
	place_item(FINISH_TILE, Vector2i(0, 0),  1, 0)
	start_building_phase()
	
func _process(delta: float) -> void:
		if Global.building_phase and tile_selector.active:
			tile_selector.move()
			
			
func _input(event: InputEvent) -> void:
	if Global.building_phase:
		if tile_selected(event):
			place_obstacle()
			tile_selector.active = false
		
		
func place_obstacle():
	if(GridManager.selected_tile_free(grid, tile_selector.pos, tile_selector.lvl)):
		place_item(STAIRS, tile_selector.pos, tile_selector.lvl)
		tile_selector.active = false
		
		if not Global.player1: end_building_phase()
		Global.player1 = !Global.player1
		

	
func tile_selected(event: InputEvent) -> bool:
	return (Global.player1 and event.is_action_pressed(InputManager.p1_controls.jump)) \
	or (!Global.player1 and event.is_action_pressed(InputManager.p2_controls.jump))
		

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
	ground_tile.global_position = tilemap_to_global(Vector2i(x, y))if (x + y) % 2 == 0:
		ground_tile.get_node("MeshInstance3D").mesh.material.albedo_texture = preload("res://tiles/ground_tile/dark_ground.png")
	
func generate_boundary_tile(x: int, y: int):
	var boundary_tile =  BOUNDARY_TILE.instantiate()
	add_child(boundary_tile, true)		
	boundary_tile.global_position = tilemap_to_global(Vector2i(x, y))

func place_item(item : PackedScene, pos : Vector2i, level : int, rot: int = 0):
	var inst = item.instantiate()
	add_child(inst, true)
	inst.global_position = tilemap_to_global(pos, level)
	inst.global_rotation.y = rot * PI / 2
	grid[GridManager.pos_lvl_to_vector3i(pos, level)] = inst

func start_building_phase():
	$Camera3D.building()
	Global.building_phase = true
	tile_selector = TILE_SELECTOR.instantiate()
	add_child(tile_selector, true)
	tile_selector.active = true
	tile_selector.global_position = tilemap_to_global(Vector2i(0,0))
	
func end_building_phase():
	$Camera3D.chase()
	Global.building_phase = false
	tile_selector.queue_free()
	
func tilemap_to_global(pos: Vector2i, level : int = 0):
	return Vector3(pos.x, 0, pos.y) * tile_size + Vector3.UP * level * tile_height
