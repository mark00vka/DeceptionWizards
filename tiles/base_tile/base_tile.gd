class_name Tile
extends Node


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		prints("Player entered tile", self)
	else:
		printerr(body, " has entered a tile")
