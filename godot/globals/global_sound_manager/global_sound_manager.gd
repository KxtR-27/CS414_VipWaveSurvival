extends Node
## plays non-locational sounds that persist across scene transitions,
## such as sounds when a button is pressed.


@onready var _button_click_player := $ButtonClickPlayer as AudioStreamPlayer
@onready var _debuff_select_player := $DebuffSelectPlayer as AudioStreamPlayer


func play_button_click_sound() -> void:
	_button_click_player.play()


func play_debuff_select_sound() -> void:
	_debuff_select_player.play()
