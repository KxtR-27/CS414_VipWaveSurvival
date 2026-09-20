extends Node

signal player_joined(device_id : DeviceIdGlobals.device_id)

var connected_player_array : Array[int] = []

var actions_dict : Dictionary = {
	"move_right" : [JOY_AXIS_LEFT_X, 1.0],
	"move_left" : [JOY_AXIS_LEFT_X, -1.0],
	"move_up" : [JOY_AXIS_LEFT_Y, -1.0],
	"move_down" : [JOY_AXIS_LEFT_Y, 1.0]
}

enum {
	JOY_AXIS = 0,
	JOY_AXIS_VALUE = 1
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join") and event.device not in connected_player_array:
		player_joined.emit(event.device as DeviceIdGlobals.device_id)
		add_player(event.device as DeviceIdGlobals.device_id)
		connected_player_array.append(event.device)


func add_player(device_id: int) -> void:
	map_direction_actions(device_id, "move_right")
	map_direction_actions(device_id, "move_left")
	map_direction_actions(device_id, "move_up")
	map_direction_actions(device_id, "move_down")
	
	player_joined.emit(device_id)
	

func map_direction_actions(device_id: int, action_name: String) -> void:
	var action: String
	var action_event: InputEventJoypadMotion
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventJoypadMotion.new()
	
	action_event.device = device_id
	action_event.axis = actions_dict[action_name][JOY_AXIS]
	action_event.axis_value = actions_dict[action_name][JOY_AXIS_VALUE]
	InputMap.action_add_event(action, action_event)
	pass
