extends Tile

func player_entered(body : Node3D) -> void:
	if body is Player:
		print(body, " won")
