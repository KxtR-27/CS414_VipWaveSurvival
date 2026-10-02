extends Node2D

@export var player_array: Array
@onready var pause_menu := $PauseMenu/CanvasLayer as CanvasLayer


func _ready() -> void:
	GlobalMusicManager.play(GlobalMusicManager.TrackOption.GAME, true)


func _on_debuff_awarder_debuff_awarder_active() -> void:
	get_tree().paused = true


func _on_debuff_awarder_debuff_awarder_finished() -> void:
	get_tree().paused = false


func _on_pause_menu_opened() -> void:
	get_tree().paused = true
	pause_menu.visible = true


func _on_pause_menu_closed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
