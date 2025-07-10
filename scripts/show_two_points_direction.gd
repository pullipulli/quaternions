extends Node

signal enable_quaternions()
signal disable_quaternions()

@export
var RAY_LENGTH = 5.0

@export
var AXIS_MULTIPLIER = 3.0

@export
var quaternion_result_label : RichTextLabel

@onready
var point_mesh : PackedScene = load("res://meshes/point.tscn")

var point : Node3D

var quaternion_enabled = false

func _ready():
	enable_quaternions.connect(_on_enable_quaternions)
	disable_quaternions.connect(_on_disable_quaternions)
	point = point_mesh.instantiate()
	add_child(point)
	point.visible = false
	

func _on_enable_quaternions():
	quaternion_enabled = true
	
	
func _on_disable_quaternions():
	quaternion_enabled = false
	$AxisLine.remove_mesh()
	point.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if not quaternion_enabled:
		return

	
	if Input.is_action_just_released("place_point"):
		if not point.visible:
			point.visible = true
			
		$"..".reset_quaternion_angle.emit()
		
		var from : Vector3 = %Camera3D.project_ray_origin(event.position)
		var to : Vector3 = from + %Camera3D.project_ray_normal(event.position) * RAY_LENGTH
		point.position = to
		
		%AxisLine.draw_line(-AXIS_MULTIPLIER*to, AXIS_MULTIPLIER*to)
		
func calculate_quaternion(angle : float):
	var axis : Vector3 = point.position.normalized()
	
	var i_component = axis.x * sin(deg_to_rad(angle) / 2)
	var j_component = axis.y * sin(deg_to_rad(angle) / 2)
	var k_component = axis.z * sin(deg_to_rad(angle) / 2)
	var real_component = cos(deg_to_rad(angle) / 2)
	
	var quaternion_string : String
	
	quaternion_string = MathUtils.decimal_to_string(real_component) + MathUtils.decimal_to_string(i_component) + "i" + \
			MathUtils.decimal_to_string(j_component) + "j" + MathUtils.decimal_to_string(k_component) + "k"
	
	print(quaternion_string)
	
	quaternion_result_label.text = quaternion_string
	
func rotate_around_axis(angle : float):
	var axis : Vector3 = point.position.normalized()	# equivalent to vector from origin to point
	if (axis == Vector3.ZERO):
		return
	
	var airplane_instance : Node3D = %GimbalsAndAirplane.airplane_instance
	
	var radians = deg_to_rad(angle)
	
	airplane_instance.rotate(axis, radians)
	
	
func reset_quaternion():
	var airplane_instance : Node3D = %GimbalsAndAirplane.airplane_instance
	airplane_instance.rotation = Vector3.ZERO
