extends Node

enum Phase {TILE_SELECT, BUILDING, CHASE}

var phase : Phase:
	set(value):
		phase = value
		MusicManager.change_phase()
		
var level : int = 1
var building_phase: bool = false
var player1: bool = true

func _ready() -> void:
	set_tile_select_phase()

func is_building_phase():
	return phase == Phase.BUILDING
	
func set_building_phase():
	phase = Phase.BUILDING
	
func is_tile_select_phase():
	return phase == Phase.TILE_SELECT
	
func set_tile_select_phase():
	phase = Phase.TILE_SELECT
	
func is_chase_phase():
	return phase == Phase.CHASE
	
func set_chase_phase():
	phase = Phase.CHASE
