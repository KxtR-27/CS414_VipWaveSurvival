class_name CharacterSelectComponent extends Control

signal index_changed
signal character_selected(sprite_frames_path : String)

@export var background : AnimatedSprite2D
@export var player_character : AnimatedSprite2D
@export var right_arrow : TextureButton
@export var left_arrow : TextureButton

@export_group("Shortcuts")
@export var right_arrow_shortcut : Shortcut = preload("res://resources/shortcuts/right_arrow_shortcut.tres")
@export var left_arrow_shortcut : Shortcut = preload("res://resources/shortcuts/left_arrow_shortcut.tres")

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

func _ready() -> void:	
	right_arrow_shortcut.events[0].device = device_id
	right_arrow.shortcut = right_arrow_shortcut
	left_arrow_shortcut.events[0].device = device_id
	left_arrow.shortcut = left_arrow_shortcut


func _on_index_changed() -> void:
	player_character.frame = character_index
	pass # Replace with function body.


func _on_right_arrow_pressed() -> void:
	character_index += 1
	index_changed.emit()
	pass # Replace with function body.


func _on_left_arrow_pressed() -> void:
	character_index -= 1
	index_changed.emit()
	pass # Replace with function body.
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		background_frame += 1
		background.frame = background_frame
		
		var sprite_frames_path := "res://resources/%s_spriteframes.tres" % characters[character_index]
		character_selected.emit(sprite_frames_path)
	#elif event.is_action_pressed("ui_right", false):
		#right_arrow.press()
	#elif event.is_action_pressed("ui_left", false):
		#left_arrow.press()
		


func _on_character_selected(_sprite_frames_path : String) -> void:
	character_has_been_selected = true
	
	right_arrow.disabled = true
	left_arrow.disabled = true
