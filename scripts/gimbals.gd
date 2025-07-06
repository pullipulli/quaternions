extends Node3D

signal update_gimbal_hierarchy(order : GimbalOrderClass.GimbalOrder)
signal disable_gimbals()
signal enable_gimbals()

enum Axis
{
	X,
	Y,
	Z
}

@onready
var gimbalX : PackedScene = load("res://meshes/coloredGimbals/gimbalX.glb")
@onready
var gimbalY : PackedScene = load("res://meshes/coloredGimbals/gimbalY.glb")
@onready
var gimbalZ : PackedScene = load("res://meshes/coloredGimbals/gimbalZ.glb")
@onready
var airplane : PackedScene = load("res://scenes/airplane.tscn")

var order : GimbalOrderClass.GimbalOrder
var first : Node3D
var second : Node3D
var third : Node3D

var airplane_instance : Node3D

var gimbal_x_instance : Node3D
var gimbal_y_instance : Node3D
var gimbal_z_instance : Node3D

var order_to_axis : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_gimbal_hierarchy.connect(_on_update_gimbal_hierarchy)
	enable_gimbals.connect(_on_enable_gimbals)
	disable_gimbals.connect(_on_disable_gimbals)
	_set_gimbal_hierarchy()
	
func _set_gimbal_hierarchy() -> void:
	
	if (first):
		first.queue_free()
	
	gimbal_x_instance = gimbalX.instantiate()
	gimbal_y_instance = gimbalY.instantiate()
	gimbal_z_instance = gimbalZ.instantiate()

	match order:
		GimbalOrderClass.GimbalOrder.XYZ:
			first = gimbal_x_instance
			second = gimbal_y_instance
			third = gimbal_z_instance
		GimbalOrderClass.GimbalOrder.XZY:
			first = gimbal_x_instance
			second = gimbal_z_instance
			third = gimbal_y_instance
		GimbalOrderClass.GimbalOrder.YZX:
			first = gimbal_y_instance
			second = gimbal_z_instance
			third = gimbal_x_instance
		GimbalOrderClass.GimbalOrder.YXZ:
			first = gimbal_y_instance
			second = gimbal_x_instance
			third = gimbal_z_instance
		GimbalOrderClass.GimbalOrder.ZXY:
			first = gimbal_z_instance
			second = gimbal_x_instance
			third = gimbal_y_instance
		GimbalOrderClass.GimbalOrder.ZYX:
			first = gimbal_z_instance
			second = gimbal_y_instance
			third = gimbal_x_instance
		_ :
			first = gimbal_x_instance
			second = gimbal_y_instance
			third = gimbal_z_instance
			
	airplane_instance = airplane.instantiate()
	
	first.scale = Vector3.ONE
	second.scale = Vector3(0.9, 0.9, 0.9)
	third.scale = Vector3(0.8, 0.8, 0.8)
	
	third.add_child(airplane_instance)
	second.add_child(third)
	first.add_child(second)
	add_child(first)


func _on_update_gimbal_hierarchy(new_gimbal_order: GimbalOrderClass.GimbalOrder) -> void:
	order = new_gimbal_order
	_set_gimbal_hierarchy()
	
func rotate_x_gimbal(euler_angle : float) -> void:
	gimbal_x_instance.rotation_degrees.x = euler_angle

func rotate_y_gimbal(euler_angle : float) -> void:
	gimbal_y_instance.rotation_degrees.y = euler_angle
	
func rotate_z_gimbal(euler_angle : float) -> void:
	gimbal_z_instance.rotation_degrees.z = euler_angle

func _on_disable_gimbals():
	third.remove_child(airplane_instance)
	get_parent().add_child(airplane_instance)
	visible = false


func _on_enable_gimbals():
	visible = true
	get_parent().remove_child(airplane_instance)
	third.add_child(airplane_instance)
	airplane_instance.rotation = Vector3.ZERO
