# class_name GlobalMusicManager
extends Node


enum TrackOption {
	MENU, GAME
}

const Tracks: Dictionary[TrackOption, String] = {
	TrackOption.MENU: "main_menu_loop",
	TrackOption.GAME: "main_game_loop"
}

@onready var player := $LoopingMusicPlayer as LoopingMusicPlayer


func play(track: TrackOption, loop: bool) -> void:
	var new_track := load(_to_path(Tracks[track])) as LoopingMusic
	player.change_music(new_track, loop)


func set_looping(loop: bool) -> void:
	player.looping = loop


func _to_path(track: String) -> String:
	return "res://resources/music_loops/%s.tres" % track
