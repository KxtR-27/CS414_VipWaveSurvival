class_name CharacterSelectComponent extends Control

signal index_changed
signal character_selected(sprite_frames_path : String, device_id : DeviceIdGlobals.device_id)

@export var background : AnimatedSprite2D
@export var player_character : AnimatedSprite2D
@export var right_arrow : TextureButton
@export var left_arrow : TextureButton

@export_group("Device Configuration")
@export var device_id : DeviceIdGlobals.device_id

@onready var background_frame : int = 0:
	set(new_frame_index):
		background_frame = clampi(new_frame_index, 0, 2)

@onready var character_index : int = 0:
	set(new_index):
		character_index = wrapi(new_index, 0, 3)
		
@onready var characters : Dictionary = {
	0 : "swordsman",
	1 : "wizard",
	2 : "knight"
}

@onready var character_has_been_selected : bool = false

func _on_index_changed() -> void:
	player_character.frame = character_index


func _on_right_arrow_pressed() -> void:
	character_index += 1
	index_changed.emit()


func _on_left_arrow_pressed() -> void:
	character_index -= 1
	index_changed.emit()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right%d" % device_id):
		character_index += 1
		index_changed.emit()
	if event.is_action_pressed("left%d" % device_id):
		character_index -= 1
		index_changed.emit()
	
	if event.is_action_pressed("select%d" % device_id):
		background_frame += 1
		background.frame = background_frame
		
		var sprite_frames_path := "res://resources/%s_spriteframes.tres" % characters[character_index]
		character_selected.emit(sprite_frames_path, device_id)


func _on_character_selected(_sprite_frames_path : String, device_id : DeviceIdGlobals.device_id) -> void:
	character_has_been_selected = true
	
	right_arrow.disabled = true
	left_arrow.disabled = true
