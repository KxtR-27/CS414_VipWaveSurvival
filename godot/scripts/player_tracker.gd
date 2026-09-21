extends Node

signal player_connected(device_id : DeviceIdGlobals.device_id)

var connected_player_array : Array[int] = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join") and event.device not in connected_player_array:
		add_player(event.device as DeviceIdGlobals.device_id)
		player_connected.emit(event.device)


func add_player(device_id: int) -> void:
	connected_player_array.append(device_id)
	
	if device_id == DeviceIdGlobals.device_id.KEYBOARD_MOUSE:
		var keyboard_mapper := KeyboardControlMapper.new()
		keyboard_mapper.add_keyboard_input_map(device_id)
	else:
		var joypad_mapper := JoypadControlMapper.new()
		joypad_mapper.add_joypad_input_map(device_id)
