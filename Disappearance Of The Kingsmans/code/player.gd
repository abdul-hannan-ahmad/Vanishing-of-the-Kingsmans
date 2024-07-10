extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY := 0.01

@onready var camera_controller: Node3D = $CameraController
@onready var camera: Camera3D = $CameraController/Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit_game"):
		get_tree().quit()
		
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		handle_rotations(event)


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	
	
func handle_movement(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	
func handle_rotations(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_controller.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))
