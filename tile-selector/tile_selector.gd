extends Node3D

const BLUE = preload("res://tile-selector/blue.tres")
const RED = preload("res://tile-selector/red.tres")
const WHITE = preload("res://tile-selector/white.tres")

@onready var cursor: MeshInstance3D = $cursor/group/pasted__group3/pasted__pasted__group2/pasted__pasted__pasted__group_001/Cursor

var pos = Vector2(0, 0)
var lvl: int = 0
var active: bool = false

func change_color(i : int):
	if i == 0:
		cursor.mesh.surface_set_material(0, BLUE)
	if i == 1:
		cursor.mesh.surface_set_material(0, RED)
	if i == 2:
		cursor.mesh.surface_set_material(0, WHITE)

func move():
	update_pos()
	if not get_parent().selected_tile_free(get_parent().grid, pos, lvl): 
		#TODO: PROMENI BOJU
		pass
	global_position = get_parent().tilemap_to_global(pos, lvl)

func update_pos():
	if Global.player1:
		pos += InputManager.get_player1_input()
		lvl += int(Input.is_action_just_pressed(InputManager.p1_controls.up)) - int(Input.is_action_just_pressed(InputManager.p1_controls.down))
	else:
		pos += InputManager.get_player2_input()
		lvl += int(Input.is_action_just_pressed(InputManager.p2_controls.up)) - int(Input.is_action_just_pressed(InputManager.p2_controls.down))

	pos.x = clamp(pos.x, 0, get_parent().map_size.x-1)
	pos.y = clamp(pos.y, 0, get_parent().map_size.y-1)
	lvl = clamp(lvl, 0, get_parent().map_size.z-1)
