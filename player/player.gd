class_name Player
extends CharacterBody3D

const CLOTHES_BLUE = preload("res://player/clothes_blue.tres")
const CLOTHES_RED = preload("res://player/clothes_red.tres")
const HAT_BLUE = preload("res://player/hat_blue.tres")
const HAT_RED = preload("res://player/hat_red.tres")

const LERP_SPEED = 2.0
const SPEED = 10.0
const JUMP_VELOCITY = 7
const GRAVITY = 17

@export var controls: PlayerControls
@export var player_blue : bool

func _ready() -> void:
	if player_blue:
		$RotationPoint/wizardNPC/pCone1.set_surface_override_material(0, CLOTHES_BLUE)
		$RotationPoint/wizardNPC/pCone2.set_surface_override_material(0, HAT_BLUE)
	else:
		$RotationPoint/wizardNPC/pCone1.set_surface_override_material(0, CLOTHES_RED)
		$RotationPoint/wizardNPC/pCone2.set_surface_override_material(0, HAT_RED)

func _physics_process(delta: float) -> void:
	if Global.is_chase_phase():
		if not is_on_floor():
			var gravity = Vector3.DOWN * GRAVITY
			if(velocity.y < 0): gravity*=2
			velocity += gravity * delta

		if Input.is_action_just_pressed(controls.jump) and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var input_dir := Input.get_vector(controls.left, controls.right, controls.fwd, controls.back)
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if velocity.y > 0:
				velocity.x += direction.x * SPEED * delta
				velocity.z += direction.z * SPEED * delta
			else:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			input_dir.x = -input_dir.x
			$RotationPoint.rotation.y = lerp_angle($RotationPoint.rotation.y, input_dir.angle(), delta * LERP_SPEED * 5)
		else:
			velocity.x = move_toward(velocity.x, 0, LERP_SPEED)
			velocity.z = move_toward(velocity.z, 0, LERP_SPEED)
		move_and_slide()
	
