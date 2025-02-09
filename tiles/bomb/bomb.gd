class_name Bomb
extends Tile

func explode():
	$ExplSmoke.restart()
	$ExplosionParticles.restart()
	SoundManager.play_sound_string("explosion")
	for body in $Area3D.get_overlapping_bodies():
		if body is Player:
			var direction: Vector3 = body.global_position - global_position + Vector3.UP * 0.5
			direction = direction.normalized()
			body.velocity = direction * 30
			
	$ExplodeTimer.start()


func _on_explode_timer_timeout() -> void:
	print()
	queue_free()
