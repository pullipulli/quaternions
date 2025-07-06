extends OptionButton

func _ready() -> void:
	_on_item_selected(get_selected_id())

func _on_item_selected(index: int) -> void:
	var gimbalOrder = GimbalOrderClass.GimbalOrder
	
	var selected_string := get_item_text(index)
	var selected_value : GimbalOrderClass.GimbalOrder
	match selected_string:
		"XYZ":
			selected_value = gimbalOrder.XYZ
		"XZY":
			selected_value = gimbalOrder.XZY
		"YZX":
			selected_value = gimbalOrder.YZX
		"YXZ":
			selected_value = gimbalOrder.YXZ
		"ZXY":
			selected_value = gimbalOrder.ZXY
		"ZYX":
			selected_value = gimbalOrder.ZYX
		_ :
			print("It should never happen")
	
	%GimbalsAndAirplane.update_gimbal_hierarchy.emit(selected_value)
