extends Node2D

@onready var character_select_scene : PackedScene =  preload("res://components/character_select_screen/character_select_screen.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(character_select_scene)
	pass # Replace with function body.
