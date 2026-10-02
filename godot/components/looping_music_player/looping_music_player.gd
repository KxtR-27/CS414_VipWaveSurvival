class_name LoopingMusicPlayer
extends Node


signal music_changed

@export var music: LoopingMusic:
	set(new_music):
		music = new_music
		music_changed.emit()
@export var looping: bool = false

@onready var start := $StartPlayer as AudioStreamPlayer
@onready var loop := $LoopPlayer as AudioStreamPlayer
@onready var end := $EndPlayer as AudioStreamPlayer


func play_start() -> void:
	if music.start != null:
		start.play()
	else:
		if music.push_missing_segment_warnings:
			push_warning(self, ": does not have a starting segment. starting from loop.")
		play_loop()


func play_loop() -> void:
	assert(music.loop != null, "Loop track cannot be null.")
	loop.play()


func play_end() -> void:
	if music.end != null:
		end.play()
	elif music.push_missing_segment_warnings:
		push_warning(self, ": does not have an ending segment.")


func change_music(to: LoopingMusic, should_loop: bool) -> void:
	for player: AudioStreamPlayer in [start, loop, end]:
		player.stop()
	
	self.music = to
	self.looping = should_loop
	self.play_start()


func is_playing() -> bool:
	for player: AudioStreamPlayer in [start, loop, end]:
		if player.playing:
			return true
	
	return false


func _on_start_player_finished() -> void:
	loop.play()


func _on_loop_player_finished() -> void:
	play_loop() if looping else play_end()


#func _on_end_player_finished() -> void:
	#pass


func _on_music_changed() -> void:
	_stop_all_players()
	_assign_new_music()
	play_start()


func _stop_all_players() -> void:
	for player: AudioStreamPlayer in [start, loop, end]:
		player.stop()


func _assign_new_music() -> void:
	for player: AudioStreamPlayer in [start, loop, end]:
		player.volume_db = music.volume_db
	
	start.stream = music.start
	loop.stream = music.loop
	end.stream = music.end
