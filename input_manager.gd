extends Node

var p1_controls: PlayerControls = preload("res://player/p1_controls.tres")
var p2_controls: PlayerControls = preload("res://player/p2_controls.tres")
var controler_sens: float = 0.1

func tile_selected(event: InputEvent) -> bool:
	return (Global.player1 and event.is_action_pressed(p1_controls.jump)) \
	or (!Global.player1 and event.is_action_pressed(p2_controls.jump))
	
func rotation(event:InputEvent) -> bool:
	return (Global.player1 and event.is_action_pressed(p1_controls.rot)) \
	or (!Global.player1 and event.is_action_pressed(p2_controls.rot))

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
