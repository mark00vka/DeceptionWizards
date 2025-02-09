extends Node3D


func _process(delta: float) -> void:
	rotate_y(delta * 0.2)
	$RemoteTransform3D.look_at(self.global_position)
