extends Node2D

@export var player_array: Array


func _on_debuff_awarder_debuff_awarder_active() -> void:
	get_tree().paused = true
	pass # Replace with function body.


func _on_debuff_awarder_debuff_awarder_finished() -> void:
	get_tree().paused = false
	pass # Replace with function body.
