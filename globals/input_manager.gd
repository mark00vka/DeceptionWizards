extends Node

var p1_controls: PlayerControls = preload("res://player/p1_controls.tres")
var p2_controls: PlayerControls = preload("res://player/p2_controls.tres")
var controler_sens: float = 0.1

func tile_selected_blue(event: InputEvent) -> bool:
	return event.is_action_pressed(p1_controls.jump)	

func tile_selected_red(event: InputEvent) -> bool:
	return event.is_action_pressed(p2_controls.jump)
	
func item_selected(event: InputEvent):
	return event.is_action_pressed(p1_controls.jump) or event.is_action_pressed(p2_controls.jump)
	
func player1_input(event: InputEvent):
	if event.is_action_pressed(p1_controls.jump): return true
	return false
	
func place_real_blue(event: InputEvent):
	return event.is_action_pressed(p1_controls.real)
	
func place_real_red(event: InputEvent):
	return event.is_action_pressed(p2_controls.real)
	
func place_fake_blue(event: InputEvent):
	return event.is_action_pressed(p1_controls.fake)
	
func place_fake_red(event: InputEvent):
	return event.is_action_pressed(p2_controls.fake)
	
func tile_rot_blue(event:InputEvent) -> bool:
	return event.is_action_pressed(p1_controls.rot)
	
func tile_rot_red(event:InputEvent) -> bool:
	return event.is_action_pressed(p2_controls.rot)

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
	
func get_player1_input():
	var move_dir = Vector2.ZERO
	if Input.is_action_just_pressed(p1_controls.fwd):
		move_dir = Vector2(0, -1)
	elif Input.is_action_just_pressed(p1_controls.back):
		move_dir = Vector2(0, 1)
	elif Input.is_action_just_pressed(p1_controls.left):
		move_dir = Vector2(-1, 0)
	elif Input.is_action_just_pressed(p1_controls.right):
		move_dir = Vector2(1, 0)
	return move_dir
