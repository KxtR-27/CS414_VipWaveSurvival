class_name KeyboardControlMapper extends Node

var movement_action_key_dict : Dictionary = {
	"move_right" : [KEY_D, KEY_RIGHT],
	"move_left" : [KEY_A, KEY_LEFT],
	"move_up" : [KEY_W, KEY_UP],
	"move_down" : [KEY_S, KEY_DOWN]
}

var button_action_key_dict : Dictionary = {
	"select" : KEY_C,
	"accept" : KEY_SPACE,
	"attack" : KEY_F,
	"ability_1" : KEY_Q,
	"ability_2" : KEY_E,
	"right" : KEY_D,
	"left" : KEY_A
}

func add_keyboard_input_map(device_id: int) -> void:
	for action : String in movement_action_key_dict:
		map_movement_action_key(device_id, action)
	for action : String in button_action_key_dict:
		map_button_action_key(device_id, action)


func map_movement_action_key(device_id: int, action_name: String) -> void:
	var action: String	
	var action_event: InputEventKey
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventKey.new()
	
	action_event.device = device_id
	action_event.keycode = movement_action_key_dict[action_name][0]
	InputMap.action_add_event(action, action_event)


func map_button_action_key(device_id: int, action_name: String) -> void:
	var action: String
	var action_event: InputEventKey
	
	action = action_name + "%d" % device_id
	InputMap.add_action(action)
	
	action_event = InputEventKey.new()
	
	action_event.device = device_id
	action_event.keycode = button_action_key_dict[action_name]
	InputMap.action_add_event(action, action_event)
