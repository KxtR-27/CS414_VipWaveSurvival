extends Node2D

signal controller_schematic_changed

@onready var controller_type_label := $Control/HBoxContainer/ColorRect/Label as Label
@onready var right_button := $Control/HBoxContainer/RightButton as TextureButton
@onready var left_button := $Control/HBoxContainer/LeftButton as TextureButton
@onready var keyboard_controls := $Control/VBoxContainer/KeyboardControls as VBoxContainer
@onready var joypad_controls := $Control/VBoxContainer/JoypadControls as VBoxContainer

var background_frame: int = 0:
	set(new_frame_index):
		background_frame = clampi(new_frame_index, 0, 2)

var controller_index: int = 0:
	set(new_index):
		controller_index = wrapi(new_index, 0, 3)

var supported_controllers: Dictionary = {
	0 : "keyboard",
	1 : "joypad"
}

func _ready() -> void:
	controller_schematic_changed.emit()


func _on_right_arrow_pressed() -> void:
	controller_index += 1
	controller_schematic_changed.emit()


func _on_left_arrow_pressed() -> void:
	controller_index -= 1
	controller_schematic_changed.emit()
	

func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("ui_right"):
		_on_right_arrow_pressed()
	if event.is_action_pressed("ui_left"):
		_on_left_arrow_pressed()


func _on_controller_schematic_changed() -> void:
	match controller_index:
		0:
			controller_type_label.text = "keyboard"
			keyboard_controls.visible = true
			joypad_controls.visible = false
		1:
			controller_type_label.text = "joypad"
			keyboard_controls.visible = false
			joypad_controls.visible = true
			
	pass # Replace with function body.
