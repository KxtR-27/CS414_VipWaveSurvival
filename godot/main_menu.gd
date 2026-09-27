extends Node2D

@onready var character_select_scene := preload("res://components/character_select_screen/character_select_screen.tscn") as PackedScene
@onready var start_button := $Control/StartButton as Button

func _ready() -> void:
	start_button.grab_focus.call_deferred()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(character_select_scene)
	pass # Replace with function body.
