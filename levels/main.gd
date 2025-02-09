@tool

extends Node3D

const GROUND_TILE = preload("res://tiles/ground_tile/ground_tile.tscn")
const BOUNDARY_TILE = preload("res://tiles/boundary_tile/boundary_tile.tscn")
const FINISH_TILE = preload("res://tiles/finish_tile/finish_tile.tscn")

const STAIRS = preload("res://tiles/stairs/stairs.tscn")
const PLATFORM = preload("res://tiles/platform_tile/platform.tscn")
const WALL = preload("res://tiles/wall_tile/wall.tscn")

var BUILD_TILES = [STAIRS, PLATFORM, WALL]

const END_SCREEN = preload("res://levels/end_screen.tscn")

const PLAYER = preload("res://player/player.tscn")

@export var map_size : Vector3i = Vector3i(4, 4, 4)
@export var tile_size : float = 5.0
@export var tile_height : float = 2.5

var player1_tiles: Array[PackedScene]
var player2_tiles: Array[PackedScene]

var grid : Dictionary = {}

@onready var pick_object_ui: Control = $PickObjectUI
@onready var tile_selector_blue: Node3D = $TileSelectorBlue
@onready var tile_selector_red: Node3D = $TileSelectorRed

signal changed_player
signal change_winner

func _ready() -> void:
	grid = {}
	player1_tiles = []
	player2_tiles = []
	generate_grid()
	$Player.global_position = tilemap_to_global(Vector2i(map_size.x-1, map_size.z-1))
	$Player2.global_position = tilemap_to_global(Vector2i(map_size.x-1, map_size.z-1)) + Vector3(1, 0, 0)
	place_item(FINISH_TILE.instantiate(), Vector2i(0, 0),  1, 1)
	Global.change_phase.connect(phase_changed)
	Global.build_timeout.connect(place_obstacle_on_tilecursor)
	Global.set_tile_select_phase()
	tile_selector_blue.change_color(0)
	tile_selector_blue.player_blue = true
	tile_selector_red.change_color(1)
	tile_selector_red.player_blue = false

		
func place_obstacle(tile_selector, real: bool):
	if(selected_tile_free(tile_selector.pos, tile_selector.lvl) or tile_selector.tile is Bomb):
		SoundManager.play_sound_string("select")
		var tile = tile_selector.tile
		if tile_selector.player_blue:
			place_item(tile, tile_selector.pos, tile_selector.lvl, real)
			player1_tiles.remove_at(0)
			if not player1_tiles.is_empty():
				tile_selector.set_tile(player1_tiles[0])
			else:
				tile_selector.active = false
				tile_selector.hide()
		else:
			place_item(tile, tile_selector.pos, tile_selector.lvl, real)
			player2_tiles.remove_at(0)
			if not player2_tiles.is_empty():
				tile_selector.set_tile(player2_tiles[0])
			else:
				tile_selector.active = false
				tile_selector.hide()
		
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
	$TileHolder.add_child(ground_tile, true)		
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
	$TileHolder.add_child(boundary_tile, true)		
	boundary_tile.global_position = tilemap_to_global(Vector2i(x, y))

func move_child_to_new_parent(child: Node, new_parent: Node):
	if child.get_parent():
		var old_parent = child.get_parent()
		old_parent.remove_child(child)
	new_parent.add_child(child, true)
	print(child.global_position)

func place_item(item : Tile, pos : Vector2i, level : int, real: bool = true, rot: int = 0):
	move_child_to_new_parent(item, $TileHolder)
	item.global_position = tilemap_to_global(pos, level)
	if rot != 0:
		item.global_rotation.y = rot * PI / 2
		
	if item is Bomb:
		var expl_pos = pos_lvl_to_vector3(pos, level)
		if grid.has(expl_pos):
			grid[expl_pos].queue_free()
			grid.erase(expl_pos)
			item.explode()
	else:
		item.real = real
		if item is FinishTile: item.end.connect(the_end)
		grid[pos_lvl_to_vector3(pos, level)] = item
		
func place_obstacle_on_tilecursor():
	if tile_selector_blue.active:
		place_obstacle(tile_selector_blue, true)
		
	if tile_selector_red.active:
		place_obstacle(tile_selector_red, true)
		
	Global.set_chase_phase()
		

func phase_changed():
	if Global.is_tile_select_phase():
		player1_tiles = []
		player2_tiles = []
		pick_object_ui.show_ui()
		%MainCamera.building()
		
	if Global.is_building_phase():
		%MainCamera.building()
		tile_selector_blue.show()
		tile_selector_blue.active = true
		tile_selector_red.show()
		tile_selector_blue.global_position = tilemap_to_global(Vector2i(0,0))
		tile_selector_red.active = true
		tile_selector_red.global_position = tilemap_to_global(Vector2i(0,0))
		tile_selector_blue.set_tile(player1_tiles[0])
		tile_selector_red.set_tile(player2_tiles[0])
		pick_object_ui.show_build_now_banner()
		
	if Global.is_chase_phase():
		%MainCamera.chase()
		tile_selector_blue.active = false
		tile_selector_blue.visible = false
		tile_selector_red.active = false
		tile_selector_red.visible = false
		pick_object_ui.show_chase_now_banner()
	
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
	
func _on_pick_object_ui_player_1_picked_tile(tile: PackedScene) -> void:
	player1_tiles.append(tile)

func _on_pick_object_ui_player_2_picked_tile(tile: PackedScene) -> void:
	player2_tiles.append(tile)

func the_end(body: Node3D):
	Global.chase_timer.stop()
	await get_tree().create_timer(1).timeout
	if body is Player:
		Global.winner_player1 = body.player_blue
		get_tree().change_scene_to_file("res://levels/end_screen.tscn")
