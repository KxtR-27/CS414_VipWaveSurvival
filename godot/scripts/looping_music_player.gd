class_name LoopingMusicPlayer
extends AudioStreamPlayer


signal music_changed

@export var music: LoopingMusic
@export var looping: bool = false


func _ready() -> void:
	if not self.finished.is_connected(_on_finished):
		self.finished.connect(_on_finished)


func play_start() -> void:
	if music.start != null:
		self.stream = music.start
		self.play()
	else:
		if music.push_missing_segment_warnings:
			push_warning(self, ": does not have a starting segment. starting from loop.")
		play_loop()


func play_loop() -> void:
	self.stream = music.loop
	self.play()


func play_end() -> void:
	self.looping = false
	if music.end != null:
		self.stream = music.end
		self.play()
	elif music.push_missing_segment_warnings:
		push_warning(self, ": does not have an ending segment.")


func change_music(to: LoopingMusic, loop: bool) -> void:
	self.stop()
	self.music = to
	self.looping = loop
	self.play_start()


func _on_finished() -> void:
	if self.stream == music.start:
		play_loop()
	elif self.stream == music.loop and looping:
		play_loop()
	elif music.end != null:
		play_end()
