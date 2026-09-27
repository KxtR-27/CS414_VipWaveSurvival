extends Control

@onready var canvas_layer := $CanvasLayer as CanvasLayer

signal pause_menu_closed
signal pause_menu_opened


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") && !canvas_layer.visible:
		pause_menu_opened.emit()
	elif event.is_action_pressed("pause") && canvas_layer.visible:
		pause_menu_closed.emit()


func _on_return_to_game_button_pressed() -> void:
	pause_menu_closed.emit()
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
