class_name ButtonAudioPlayer
extends AudioStreamPlayer


func _ready() -> void:
	var parent := get_parent()
	if parent is Button:
		var button := parent as Button
		button.pressed.connect(self.play)
	else:
		push_warning(self, " - parent ", parent, " is not a button.")
