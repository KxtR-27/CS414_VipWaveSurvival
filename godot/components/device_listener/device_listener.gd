class_name DeviceListener
extends Node


func _input(event: InputEvent) -> void:
	var device := event.device
	var is_new_device := not DeviceManager.has_device(event.device)
	var device_is_mouse := device == 32
	
	# register a new device
	if is_new_device:
		DeviceManager.add_device(device)
		print(
				"new device added from listener: device ", "[KBM]" if (device == 32 or device == 16) 
				else "%d" % device
		)
	
	# if the input event came from the mouse, set the flag to true
	# this is used in hurtbox aiming process
	if not DeviceManager.mouse_detected and device_is_mouse:
		DeviceManager.mouse_detected = true
