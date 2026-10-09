# class_name GlobalMusicManager
extends Node


enum TrackOption {
	MENU, GAME
}

const Tracks: Dictionary[TrackOption, String] = {
	TrackOption.MENU: "main_menu_loop",
	TrackOption.GAME: "main_game_loop"
}


var current_track: TrackOption

@onready var music_player := $LoopingMusicPlayer as LoopingMusicPlayer


func play(track: TrackOption, loop: bool) -> void:
	var new_track := load(_to_path(Tracks[track])) as LoopingMusic
	current_track = track
	music_player.change_music(new_track, loop)


func set_looping(loop: bool) -> void:
	music_player.looping = loop


func is_playing() -> bool:
	return music_player.is_playing()


func _to_path(track: String) -> String:
	return "res://resources/music_loops/%s.tres" % track
