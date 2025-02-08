extends Node3D

var pos = Vector2(0, 0)
var lvl: int = 0
var active: bool = false

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
	
func move():
	update_pos()
	if not GridManager.selected_tile_free(get_parent().grid, pos, lvl): 
		#TODO: PROMENI BOJU
		pass
	global_position = get_parent().tilemap_to_global(pos, lvl)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
