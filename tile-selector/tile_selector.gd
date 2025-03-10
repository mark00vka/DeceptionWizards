extends Node3D

@export var player_blue : bool = true

const BLUE = preload("res://tile-selector/blue.tres")
const RED = preload("res://tile-selector/red.tres")
const WHITE = preload("res://tile-selector/white.tres")

@onready var cursor: MeshInstance3D = $cursor/group/pasted__group3/pasted__pasted__group2/pasted__pasted__pasted__group_001/Cursor2

var pos = Vector2(0, 0)
var lvl: int = 0
var active: bool = false

var tile : Tile

func clear_tile():
	if tile.get_parent() == self:
		tile.queue_free()
	tile = null

func set_tile(t: PackedScene):
	if tile and tile.get_parent() == self:
		tile.queue_free()
	tile = t.instantiate()
	add_child(tile)

	
func _input(event: InputEvent) -> void:
	if Global.is_building_phase():
		if tile is Bomb and not on_free_tile():
			if (InputManager.place_real_blue(event) and player_blue) \
			or (InputManager.place_real_red(event) and not player_blue) and active:
				SoundManager.play_sound_string("select")
				get_parent().place_obstacle(self, true)
			
			if (InputManager.place_fake_blue(event) and player_blue) \
			or (InputManager.place_fake_red(event) and not player_blue) and active:
				SoundManager.play_sound_string("select")
				get_parent().place_obstacle(self, false)
					
			if (InputManager.tile_selected_blue(event) and player_blue)\
				or (InputManager.tile_selected_red(event) and not player_blue) and active:
				SoundManager.play_sound_string("select")
				Global.finished_placement+=1
				if Global.finished_placement == 6:
					Global.set_chase_phase()
				
				if (player_blue and get_parent().player1_tiles.is_empty())\
				or (not player_blue and get_parent().player2_tiles.is_empty()):
					hide()
					active = false
			
			if (InputManager.tile_rot_blue(event) and player_blue)\
				or (InputManager.tile_rot_red(event) and not player_blue) and active:
				SoundManager.play_sound_string("rotate")
				rotate_obstacle()
				
		elif on_free_tile():
			if (InputManager.place_real_blue(event) and player_blue) \
			or (InputManager.place_real_red(event) and not player_blue) and active:
				SoundManager.play_sound_string("select")
				get_parent().place_obstacle(self, true)
			
			if (InputManager.place_fake_blue(event) and player_blue) \
			or (InputManager.place_fake_red(event) and not player_blue) and active:
				SoundManager.play_sound_string("select")
				get_parent().place_obstacle(self, false)
					
					
		if (InputManager.tile_selected_blue(event) and player_blue)\
			or (InputManager.tile_selected_red(event) and not player_blue) and active:
			SoundManager.play_sound_string("select")
			Global.finished_placement+=1
			if Global.finished_placement == 6:
				Global.set_chase_phase()
			
			if (player_blue and get_parent().player1_tiles.is_empty())\
			or (not player_blue and get_parent().player2_tiles.is_empty()):
				hide()
				active = false
		
		if (InputManager.tile_rot_blue(event) and player_blue)\
			or (InputManager.tile_rot_red(event) and not player_blue) and active:
			SoundManager.play_sound_string("rotate")
			rotate_obstacle()
			
func rotate_obstacle():
	tile.global_rotation.y += PI/2

func _process(_delta: float) -> void:
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
	elif cursor.mesh.surface_get_material(0) == WHITE or tile is Bomb:
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
		lvl += lvl_input		
		lvl = clamp(lvl, 0, get_parent().map_size.y-1)
		
		pos += input
		pos.x = clamp(pos.x, 0, get_parent().map_size.x-1)
		pos.y = clamp(pos.y, 0, get_parent().map_size.z-1)
		
		SoundManager.play_sound_string("click")
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", get_parent().tilemap_to_global(pos, lvl), 0.1).set_trans(Tween.TRANS_CUBIC)


func on_free_tile():
	return get_parent().selected_tile_free(pos, lvl)
