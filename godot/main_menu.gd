extends Node2D

@onready var main_scene :=  preload("res://main.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)
	pass # Replace with function body.
