extends Node

var connected_player_array : Array[int] = []

var movement_action_joy_dict : Dictionary = {
	"move_right" : [JOY_AXIS_LEFT_X, 1.0],
	"move_left" : [JOY_AXIS_LEFT_X, -1.0],
	"move_up" : [JOY_AXIS_LEFT_Y, -1.0],
	"move_down" : [JOY_AXIS_LEFT_Y, 1.0]
}

var movement_action_key_dict : Dictionary = {
	"move_right" : [KEY_D, KEY_RIGHT],
	"move_left" : [KEY_A, KEY_LEFT],
	"move_up" : [KEY_W, KEY_UP],
	"move_down" : [KEY_S, KEY_DOWN]
}

var button_action_joy_dict : Dictionary = {
	"select" : JOY_BUTTON_Y,
	"accept" : JOY_BUTTON_A,
	"attack" : JOY_BUTTON_A,
	"ability_1" : JOY_BUTTON_X,
	"ability_2" : JOY_BUTTON_Y
}

var button_action_key_dict : Dictionary = {
	"select" : KEY_C,
	"accept" : KEY_SPACE,
	"attack" : KEY_F,
	"ability_1" : KEY_Q,
	"ability_2" : KEY_E
}

enum {
	JOY_AXIS = 0,
	JOY_AXIS_VALUE = 1
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join") and event.device not in connected_player_array:
		add_player(event.device as DeviceIdGlobals.device_id)
		#print(event.device)
		connected_player_array.append(event.device)


func add_player(device_id: int) -> void:
	if device_id == DeviceIdGlobals.device_id.KEYBOARD_MOUSE:
		for action : String in movement_action_key_dict:
			map_movement_actions_key(device_id, action)
	else:
		for action : String in movement_action_joy_dict:
			map_movement_actions_joy(device_id, action)
	
	if device_id == DeviceIdGlobals.device_id.KEYBOARD_MOUSE:
		for action : String in button_action_key_dict:
			map_button_actions_key(device_id, action)
	else:
		for action : String in button_action_joy_dict:
			map_button_actions_joy(device_id, action)
	

func map_movement_actions_joy(device_id: int, action_name: String) -> void:
	var action: String	
	var action_event: InputEventJoypadMotion
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventJoypadMotion.new()
	
	action_event.device = device_id
	action_event.axis = movement_action_joy_dict[action_name][JOY_AXIS]
	action_event.axis_value = movement_action_joy_dict[action_name][JOY_AXIS_VALUE]
	InputMap.action_add_event(action, action_event)


func map_button_actions_joy(device_id: int, action_name: String) -> void:
	var action: String
	var action_event: InputEventJoypadButton
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventJoypadButton.new()
	
	action_event.device = device_id
	action_event.button_index = button_action_joy_dict[action_name]
	InputMap.action_add_event(action, action_event)
	

func map_movement_actions_key(device_id: int, action_name: String) -> void:
	var action: String	
	var action_event: InputEventKey
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventKey.new()
	
	action_event.device = device_id
	action_event.keycode = movement_action_key_dict[action_name][0]
	InputMap.action_add_event(action, action_event)


func map_button_actions_key(device_id: int, action_name: String) -> void:
	var action: String
	var action_event: InputEventKey
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventKey.new()
	
	action_event.device = device_id
	action_event.keycode = button_action_key_dict[action_name]
	InputMap.action_add_event(action, action_event)
