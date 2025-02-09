class_name Player
extends CharacterBody3D

const LERP_SPEED = 2.0
const SPEED = 10.0
const JUMP_VELOCITY = 7
const GRAVITY = 17

@export var controls: PlayerControls
@export var color : Color

func _ready() -> void:
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	$MeshInstance3D.mesh.material = material

func _physics_process(delta: float) -> void:
	if Global.is_building_phase() or Global.is_tile_select_phase():
		return

	# Add the gravity.
	if not is_on_floor():
		var gravity = Vector3.DOWN * GRAVITY
		if(velocity.y < 0): gravity*=2
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(controls.jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector(controls.left, controls.right, controls.fwd, controls.back)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, LERP_SPEED)
		velocity.z = move_toward(velocity.z, 0, LERP_SPEED)

	move_and_slide()
	
