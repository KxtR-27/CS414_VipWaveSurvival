extends Node


signal game_won
signal game_lost


func win_game() -> void:
	game_won.emit()

func lose_game() -> void:
	game_lost.emit()
