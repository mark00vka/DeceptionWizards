class_name Tile
extends Node

var real = true

func player_entered(body: Node3D) -> void:
	if not real: 
		await get_tree().create_timer(1).timeout
		queue_free()
