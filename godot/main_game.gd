extends Node2D

@export var player_array: Array
@onready var pause_menu := $PauseMenu/CanvasLayer as CanvasLayer


func _on_debuff_awarder_debuff_awarder_active() -> void:
	get_tree().paused = true
	pass # Replace with function body.


func _on_debuff_awarder_debuff_awarder_finished() -> void:
	get_tree().paused = false
	pass # Replace with function body.


func _on_pause_menu_opened() -> void:
	get_tree().paused = true
	pause_menu.visible = true
	pass # Replace with function body.


func _on_pause_menu_closed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	pass # Replace with function body.
