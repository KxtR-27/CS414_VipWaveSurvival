class_name ButtonAudioPlayer
extends AudioStreamPlayer


func _ready() -> void:
	var parent := get_parent()
	if parent is Button:
		var button := parent as Button
		button.pressed.connect(self.play)
		self.finished.connect(
			func() -> void: 
				button.disabled = false
		)
	else:
		push_warning(self, " - parent ", parent, " is not a button.")


func _play_and_disable() -> void:
	self.play()
	(get_parent() as Button).disabled = true
