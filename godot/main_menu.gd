extends Node2D


@onready var character_select_scene := preload("res://components/character_select_screen/character_select_screen.tscn") as PackedScene
@onready var start_button := $Control/StartButton as Button
@onready var start_button_sound := $Control/StartButton/ButtonSound as AudioStreamPlayer


func _ready() -> void:
	start_button.grab_focus.call_deferred()
	# play menu music if menu music isn't already playing
	if (
			not GlobalMusicManager.is_playing() 
			or GlobalMusicManager.current_track != GlobalMusicManager.TrackOption.MENU
	):
		GlobalMusicManager.play(GlobalMusicManager.TrackOption.MENU, true)


func _on_start_button_pressed() -> void:
	await start_button_sound.finished
	get_tree().change_scene_to_packed(character_select_scene)


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://components/controls_menu/controls_menu.tscn")
