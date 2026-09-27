extends Control

@onready var canvas_layer := $CanvasLayer as CanvasLayer
@onready var button_to_focus_on_first := $CanvasLayer/Panel/VBoxContainer/SaveButton as Button

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


func _on_pause_menu_opened() -> void:
	button_to_focus_on_first.grab_focus.call_deferred()
	pass # Replace with function body.
