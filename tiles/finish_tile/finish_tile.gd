class_name FinishTile
extends Tile

signal end(body)

func player_entered(body : Node3D) -> void:
	if body is Player:
		end.emit(body)
