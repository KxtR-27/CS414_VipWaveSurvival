class_name CharacterSelectComponent extends Control

signal index_changed
signal character_selected(sprite_frames_path : String, device_id : int)

@onready var background := $BackgroundBox as AnimatedSprite2D
@onready var player_character := $PlayerCharacter as AnimatedSprite2D
@onready var right_arrow := $RightArrow as TextureButton
@onready var left_arrow := $LeftArrow as TextureButton

@export_group("Device Configuration")
@export var device_id: int = -2

var background_frame : int = 0:
	set(new_frame_index):
		background_frame = clampi(new_frame_index, 0, 2)

var character_index : int = 0:
	set(new_index):
		character_index = wrapi(new_index, 0, 3)
		player_character.frame = character_index
		
var characters : Dictionary = {
	0 : "swordsman",
	1 : "wizard",
	2 : "knight"
}

var character_has_been_selected : bool = false

func _on_index_changed() -> void:
	player_character.frame = character_index

func _on_right_arrow_pressed() -> void:
	character_index += 1
	index_changed.emit()

func _on_left_arrow_pressed() -> void:
	character_index -= 1
	index_changed.emit()
	

func _input(event: InputEvent) -> void:
	var is_kbm_and_I_use_kbm := self.device_id == 16 and DeviceManager.is_kbm(event.device)
	var is_my_device := event.device == self.device_id
	
	var should_continue := is_kbm_and_I_use_kbm or is_my_device
	if not should_continue:
		return
	
	print("sending event through: ", event)
	print("is kbm and I use kbm: ", is_kbm_and_I_use_kbm)
	print("is my device: ", is_my_device)
	
	if event.is_action_pressed("ui_right"):
		_on_right_arrow_pressed()
	if event.is_action_pressed("ui_left"):
		_on_left_arrow_pressed()
	if event.is_action_pressed("ui_select"):
		background_frame += 1
		background.frame = background_frame
		
		var sprite_frames_path := "res://resources/%s_spriteframes.tres" % characters[character_index]
		character_selected.emit(sprite_frames_path, device_id)


func _on_character_selected(_sprite_frames_path: String, _device_id: int) -> void:
	character_has_been_selected = true
	right_arrow.disabled = true
	left_arrow.disabled = true
