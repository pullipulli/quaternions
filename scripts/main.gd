extends Node3D

signal reset_quaternion_angle()

enum RotationMode
{
	EULER,
	QUATERNION
}

@export
var gimbals_ui : Node2D

@export
var quaternions_ui : Node2D

@export
var x_slider : HSlider

@export
var y_slider : HSlider

@export
var z_slider : HSlider

@export
var quaternion_slider : HSlider

@export
var quaternion_angle_label : Label

var current_mode : RotationMode = RotationMode.EULER

func _ready():
	reset_quaternion_angle.connect(_on_reset_quaternion_angle)
	

func _on_reset_quaternion_angle():
	quaternion_slider.value = 0
	quaternion_slider.editable = true
	

func _on_x_slider_value_changed(value: float) -> void:
	%GimbalsAndAirplane.rotate_x_gimbal(value)


func _on_y_slider_value_changed(value: float) -> void:
	%GimbalsAndAirplane.rotate_y_gimbal(value)


func _on_z_slider_value_changed(value: float) -> void:
	%GimbalsAndAirplane.rotate_z_gimbal(value)


func _on_switch_rotation_mode_pressed() -> void:
	if current_mode == RotationMode.QUATERNION:
		current_mode = RotationMode.EULER
		%GimbalsAndAirplane.enable_gimbals.emit()
		gimbals_ui.visible = true
		%ShowTwoPointsDirection.disable_quaternions.emit()
		quaternions_ui.visible = false
		x_slider.value = 0
		y_slider.value = 0
		z_slider.value = 0
	else:
		current_mode = RotationMode.QUATERNION
		%GimbalsAndAirplane.disable_gimbals.emit()
		gimbals_ui.visible = false
		%ShowTwoPointsDirection.enable_quaternions.emit()
		quaternions_ui.visible = true
		quaternion_slider.value = 0
		quaternion_slider.editable = false


func _on_rotate_quaternion_button_button_up() -> void:
	%ShowTwoPointsDirection.rotate_around_axis(quaternion_slider.value)


func _on_quaternion_angle_value_changed(value: float) -> void:
	quaternion_angle_label.text = str(value) + ' °'
	%ShowTwoPointsDirection.calculate_quaternion(value)
