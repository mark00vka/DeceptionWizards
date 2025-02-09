extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel
@onready var object_holder: Control = $Panel/ObjectHolder
@onready var stairs: TextureRect = $Panel/ObjectHolder/Stairs
@onready var wall: TextureRect = $Panel/ObjectHolder/Wall
@onready var platform: TextureRect = $Panel/ObjectHolder/Platform

@onready var cursor_p_1: Cursor = $Panel/ObjectHolder/CursorP1
@onready var cursor_p_2: Cursor = $Panel/ObjectHolder/CursorP2

signal cursors_hidden
signal player1_picked_tile(tile : PackedScene)
signal player2_picked_tile(tile : PackedScene)

var x_pull : Array[float] = []
var y_pull : Array[float] = []

var distance_from_cursor:float = 50

func _ready() -> void:
	Global.tile_select_timeout.connect(select_random_tiles)

func show_ui():
	show()
	cursor_p_1.show()
	cursor_p_2.show()
	color_rect.modulate.a = 0
	panel.position.y = 900
	animate_ui(38)
	
	x_pull.clear()
	y_pull.clear()
	for i in range(8):
		x_pull.append(i*0.75/8)
		y_pull.append(i*0.75/8)

	place_items(x_pull, y_pull)
	
func place_items(x_p, y_p):
	for i in range(randi() % 3 + 6):
		var inst
		var t = randf()
		if t < 0.5:
			inst = stairs.duplicate()
		elif t < 0.75:
			inst = wall.duplicate()
		else:
			inst = platform.duplicate()
		object_holder.add_child(inst)
		inst.show()
		
		var x = x_p.pick_random()
		var y = y_p.pick_random()
		x_p.erase(x)
		y_p.erase(y)
		inst.set_pos(x, y)

func animate_ui(end_y_position: int):
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(color_rect, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(panel, "position:y", end_y_position, 1.0).set_trans(Tween.TRANS_CUBIC)

func _input(event: InputEvent) -> void:
	if InputManager.item_selected(event):
		select_item(InputManager.player1_input(event))
		
func select_item(player1: bool):
	for child in $Panel/ObjectHolder.get_children():
		
		if child.visible == false or child is Cursor: 
			continue
			
		if player1 \
		and cursor_p_1.visible \
		and child.global_position.distance_to(cursor_p_1.global_position - cursor_p_1.get_rect().size/2) < distance_from_cursor:
			player1_picked_tile.emit(child.tile.tile)
			child.queue_free()
			cursor_p_1.hide()
			if not cursor_p_2.visible: 
				cursors_hidden.emit()
				break
			
		if not player1\
		and cursor_p_2.visible\
		and child.global_position.distance_to(cursor_p_2.global_position - cursor_p_2.get_rect().size/2) < distance_from_cursor:
			player2_picked_tile.emit(child.tile.tile)
			child.queue_free()
			cursor_p_2.hide()
			if not cursor_p_1.visible: 
				cursors_hidden.emit()
				break


func _on_cursors_hidden() -> void:
	animate_ui(900)
	await get_tree().create_timer(1).timeout
	Global.set_building_phase()

func select_random_tiles():
	var i = randi_range(0, $Panel/ObjectHolder.get_children().size()-1)
	var rand_tile = $Panel/ObjectHolder.get_children()[i]
	
	while rand_tile.visible == false or rand_tile is Cursor:
		i = randi_range(0, $Panel/ObjectHolder.get_children().size()-1)
		rand_tile = $Panel/ObjectHolder.get_children()[i]
	
	if cursor_p_1.visible:
		player1_picked_tile.emit(rand_tile.tile.tile)
		rand_tile.queue_free()
		cursor_p_1.hide()
		if not cursor_p_2.visible: 
			cursors_hidden.emit()
			
	i = randi_range(0, $Panel/ObjectHolder.get_children().size()-1)
	rand_tile = $Panel/ObjectHolder.get_children()[i]
	
	while rand_tile.visible == false or rand_tile is Cursor:
		i = randi_range(0, $Panel/ObjectHolder.get_children().size()-1)
		rand_tile = $Panel/ObjectHolder.get_children()[i]			
			
	if cursor_p_2.visible:
		player2_picked_tile.emit(rand_tile.tile.tile)
		rand_tile.queue_free()
		cursor_p_2.hide()
		if not cursor_p_1.visible: 
			cursors_hidden.emit()
