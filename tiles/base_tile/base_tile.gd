class_name Tile
extends Node


func _on_area_3d_body_entered(body: Node3D) -> void:
	prints("entered tile", self)
