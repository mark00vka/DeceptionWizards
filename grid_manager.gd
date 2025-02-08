extends Node

func selected_tile_free(grid: Dictionary, tile_pos: Vector2i, tile_lvl: int) -> bool:
	return !grid.has(pos_lvl_to_vector3i(tile_pos, tile_lvl))

func pos_lvl_to_vector3i(pos: Vector2i, lvl: int) -> Vector3i:
	return Vector3i(pos.x, lvl, pos.y)
