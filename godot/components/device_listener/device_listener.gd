class_name DeviceListener
extends Node


func _input(event: InputEvent) -> void:
	var device := event.device
	var is_new_device := not DeviceManager.has_device(event.device)
	
	if is_new_device:
		DeviceManager.add_device(device)
		print(
				"new device added from listener: device ", "[KBM]" if (device == 32 or device == 16) 
				else "%d" % device
		)
