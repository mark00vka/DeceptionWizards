extends Node3D

@export var player_blue : bool = true

const BLUE = preload("res://tile-selector/blue.tres")
const RED = preload("res://tile-selector/red.tres")
const WHITE = preload("res://tile-selector/white.tres")

@onready var cursor: MeshInstance3D = $cursor/group/pasted__group3/pasted__pasted__group2/pasted__pasted__pasted__group_001/Cursor2

var pos = Vector2(0, 0)
var lvl: int = 0
var active: bool = false

var tile_not_selected: bool = true
var tile : Tile

func clear_tile():
	if tile:
		tile.queue_free()
	tile = null

func set_tile(t: PackedScene):
	if tile:
		tile.queue_free()
	else:
		tile = t.instantiate()
		add_child(tile)

func _process(delta: float) -> void:
	if Global.is_building_phase() and active:
		move()

func change_color(i : int):
	if i == 0:
		cursor.mesh.surface_set_material(0, BLUE)
	if i == 1:
		cursor.mesh.surface_set_material(0, RED)
	if i == 2:
		cursor.mesh.surface_set_material(0, WHITE)

func move():
	update_pos()
	if not on_free_tile(): 
		change_color(2)
	elif cursor.mesh.surface_get_material(0) == WHITE:
		change_color(int(not player_blue))

func update_pos():
	var input
	var lvl_input
	
	if player_blue:
		input = InputManager.get_player1_input()
		lvl_input = int(Input.is_action_just_pressed(InputManager.p1_controls.up)) - int(Input.is_action_just_pressed(InputManager.p1_controls.down))
	else:
		input = InputManager.get_player2_input()
		lvl_input = int(Input.is_action_just_pressed(InputManager.p2_controls.up)) - int(Input.is_action_just_pressed(InputManager.p2_controls.down))
		
	if input or lvl_input:
		pos += input
		lvl += lvl_input		
		lvl = clamp(lvl, 0, get_parent().map_size.y-1)
		pos.x = clamp(pos.x, 0, get_parent().map_size.x-1)
		pos.y = clamp(pos.y, 0, get_parent().map_size.z-1)
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", get_parent().tilemap_to_global(pos, lvl), 0.1).set_trans(Tween.TRANS_CUBIC)


func on_free_tile():
	return get_parent().selected_tile_free(pos, lvl)
