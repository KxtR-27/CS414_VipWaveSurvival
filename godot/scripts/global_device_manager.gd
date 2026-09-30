extends Node


signal connected_devices_updated

var _connected_devices: Array[int] = []

var banned_devices: Array[int] = [
	-1, # touch/emulated (not supported)
	32, # mouse (merged with keyboard for KBM)
]

var mouse_detected: bool = false


func _input(event: InputEvent) -> void:
	if (not mouse_detected) and event.device == 32:
		mouse_detected = true


func add_device(device: int) -> void:
	if is_kbm(device):
		if not self._connected_devices.has(16):
			self._connected_devices.append(16)
			connected_devices_updated.emit()
	else:
		if not self._connected_devices.has(device):
			self._connected_devices.append(device)
			connected_devices_updated.emit()


func has_device(device: int) -> bool:
	if banned_devices.has(device):
		return true # to stop a listener from trying to add it again
	
	if is_kbm(device):
		return self._connected_devices.has(16)
	else:
		return self._connected_devices.has(device)


func get_devices() -> Array[int]:
	var immutable_copy: Array[int] = self._connected_devices.duplicate()
	immutable_copy.make_read_only()
	return immutable_copy


func is_kbm(device: int) -> bool:
	return device == 16 or device == 32
