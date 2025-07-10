extends Camera3D

@export
var MOVEMENT_SPEED : float = 10
@export
var ROTATION_SENSITIVITY : float = 0.005

var movement_enabled : bool = false

var initial_position : Vector3

func _init() -> void:
	initial_position = position

func _unhandled_input(event: InputEvent) -> void:
	if not movement_enabled:
		return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * ROTATION_SENSITIVITY)
		rotate_x(-event.relative.y * ROTATION_SENSITIVITY)
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _process(delta: float) -> void:
	if (Input.is_action_just_released("enable_movement")):
		if movement_enabled:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			movement_enabled = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			movement_enabled = true
	
	if not movement_enabled:
		return
	
	var input_dir := Vector3()
	
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	input_dir.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	position += calculate_move_direction(input_dir) * MOVEMENT_SPEED * delta
	
func calculate_move_direction(input_dir: Vector3) -> Vector3:
	var cam_basis = global_transform.basis
	var direction = Vector3.ZERO
	
	direction -= cam_basis.z * input_dir.z  # Avanti/Indietro
	direction += cam_basis.x * input_dir.x  # Destra/Sinistra
	direction += cam_basis.y * input_dir.y  # Su/Giù

	return direction.normalized()
	
func reset_camera():
	position = initial_position
