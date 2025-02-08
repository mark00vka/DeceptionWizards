extends CharacterBody3D

signal generate_mesh
signal add_point(pos: Vector2)

# PLAYER NODES

@onready var head: Node3D = $Head
@onready var standing_shape = $StandingShape
@onready var crouching_shape = $CrouchingShape
@onready var standing_ray = $StandingRay
@onready var point_ray = $Head/PointRay
@onready var drawing_plane: CSGMesh3D = $DrawingPlane

#SPEED VARS

var current_speed: float = 5.0
@export var walking_speed: float = 3.0
@export var sprinting_speed: float = 8.0
@export var crouching_speed: float = 3.0

#MOVEMENT VARS

const JUMP_VELOCITY = 4.5
var lerp_speed: float = 10.0
var crouching_depth: float = -0.5
var direction: Vector3 = Vector3.ZERO
var drawing : bool = false
var drawing_mode : bool = false

#INPUT VARS

@export var mouse_sens: float = 0.4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sens)
		head.rotate_x(-event.relative.y * mouse_sens)
		head.rotation.x = clamp(head.rotation.x, -1.2, 1.2)
	
	if event.is_action_pressed("tab"):
		drawing_mode = not drawing_mode

func _physics_process(delta):
	
	#HANDLE MOVEMENT STATE
	if Input.is_action_pressed("crouch"):
		#crouching
		
		head.position.y = lerp(head.position.y, 0.6 + crouching_depth, delta * lerp_speed)
		current_speed = crouching_speed
		standing_shape.disabled = true
		crouching_shape.disabled = false

	elif !standing_ray.is_colliding():
		#standing
		standing_shape.disabled = false
		crouching_shape.disabled = true
		head.position.y = lerp(head.position.y, 0.6, delta * lerp_speed)
		#HANDLE SPRINTING
		if Input.is_action_pressed("sprint"):
			#sprinting
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func _on_drawing_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:		
	if event is InputEventMouseButton:
		if event.is_released():
			generate_mesh.emit()
			drawing = false
		if event.is_pressed():
			drawing = true
	
	if event is InputEventMouseMotion and drawing and Engine.get_process_frames() % 4 == 0:
		add_point.emit(event_position - $DrawingPlane.global_position)

func _on_drawing_area_mouse_exited() -> void:
	generate_mesh.emit()
	drawing = false
