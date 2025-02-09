extends Control

signal change_phase

enum Phase {TILE_SELECT, BUILDING, CHASE}

@onready var tile_select_timer: Timer = $TileSelectTimer
@onready var building_timer: Timer = $BuildingTimer
@onready var chase_timer: Timer = $ChaseTimer


var phase : Phase:
	set(value):
		phase = value
		tile_select_timer.stop()
		building_timer.stop()
		chase_timer.stop()
		change_phase.emit()
		
var level : int = 1
var finished_placement : int = 0

signal tile_select_timeout
signal build_timeout

func _process(_delta: float) -> void:
	var text
	if is_building_phase():
		text = building_timer.time_left
	if is_tile_select_phase():
		text = tile_select_timer.time_left
	if is_chase_phase():
		text = chase_timer.time_left
		
	$Label.text = "%02d." % (int(text)) + "%02d" % (int(text*100)%100)

func is_building_phase():
	return phase == Phase.BUILDING
	
func set_building_phase():
	print("aaa")
	phase = Phase.BUILDING
	finished_placement = 0
	building_timer.start()	
	
func is_tile_select_phase():
	return phase == Phase.TILE_SELECT
	
func set_tile_select_phase():
	phase = Phase.TILE_SELECT
	tile_select_timer.start()
	
func is_chase_phase():
	return phase == Phase.CHASE
	
func set_chase_phase():
	phase = Phase.CHASE
	chase_timer.start()


func _on_tile_select_timer_timeout() -> void:
	tile_select_timeout.emit()
	await get_tree().create_timer(1).timeout
	set_building_phase()


func _on_building_timer_timeout() -> void:
	build_timeout.emit()
	await get_tree().create_timer(1).timeout
	set_chase_phase()


func _on_chase_timer_timeout() -> void:
	chase_timer.stop()
	await get_tree().create_timer(1).timeout
	set_tile_select_phase()
