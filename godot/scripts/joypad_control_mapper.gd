class_name JoypadControlMapper extends Node

var movement_action_joy_dict : Dictionary = {
	"move_right" : [JOY_AXIS_LEFT_X, 1.0],
	"move_left" : [JOY_AXIS_LEFT_X, -1.0],
	"move_up" : [JOY_AXIS_LEFT_Y, -1.0],
	"move_down" : [JOY_AXIS_LEFT_Y, 1.0]
}

var button_action_joy_dict : Dictionary = {
	"select" : JOY_BUTTON_Y,
	"accept" : JOY_BUTTON_A,
	"attack" : JOY_BUTTON_A,
	"ability_1" : JOY_BUTTON_X,
	"ability_2" : JOY_BUTTON_Y,
	"right" : JOY_BUTTON_DPAD_RIGHT,
	"left" : JOY_BUTTON_DPAD_LEFT
}

enum {
	JOY_AXIS = 0,
	JOY_AXIS_VALUE = 1
}

func add_joypad_input_map(device_id: int) -> void:
	for action : String in movement_action_joy_dict:
		map_movement_action_joy(device_id, action)
	for action : String in button_action_joy_dict:
		map_button_action_joy(device_id, action)
		

func map_movement_action_joy(device_id: int, action_name: String) -> void:
	var action: String	
	var action_event: InputEventJoypadMotion
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventJoypadMotion.new()
	
	action_event.device = device_id
	action_event.axis = movement_action_joy_dict[action_name][JOY_AXIS]
	action_event.axis_value = movement_action_joy_dict[action_name][JOY_AXIS_VALUE]
	InputMap.action_add_event(action, action_event)


func map_button_action_joy(device_id: int, action_name: String) -> void:
	var action: String
	var action_event: InputEventJoypadButton
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventJoypadButton.new()
	
	action_event.device = device_id
	action_event.button_index = button_action_joy_dict[action_name]
	InputMap.action_add_event(action, action_event)
