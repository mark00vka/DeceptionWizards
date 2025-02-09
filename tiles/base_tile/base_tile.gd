class_name Tile
extends Node3D

var real = true

func player_entered(body: Node3D) -> void:
	if not real:
		hide_all()
		if randf() < 0.9:
			$ExplSmoke.restart()
			$ExplosionParticles.restart()
			if body is Player:
				var direction: Vector3 = body.global_position - global_position + Vector3.UP * 0.5
				direction = direction.normalized()
				body.velocity = direction * 30
		else:
			$DisappearParticles.restart()
func hide_all():
	for c in get_children():
		if c is not GPUParticles3D:
			c.hide()
			if c is Area3D or c is Node3D:
				c.queue_free()
