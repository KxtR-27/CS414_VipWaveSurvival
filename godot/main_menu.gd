extends Node2D


@onready var character_select_scene := preload("res://ui_components/character_select_screen/character_select_screen.tscn") as PackedScene
@onready var start_button := $CanvasLayer/Control/VBoxContainer/StartButton as Button


func _ready() -> void:
	start_button.grab_focus.call_deferred()
	# play menu music if menu music isn't already playing
	if (
			not GlobalMusicManager.is_playing() 
			or GlobalMusicManager.current_track != GlobalMusicManager.TrackOption.MENU
	):
		GlobalMusicManager.play(GlobalMusicManager.TrackOption.MENU, true)
		
		update_inrun_ability_progression_tag()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_in_run_upgrades"):
		InrunAbilityUpgradeEnabler.is_enabled = not InrunAbilityUpgradeEnabler.is_enabled
		update_inrun_ability_progression_tag()
		

func update_inrun_ability_progression_tag() -> void:
	var text_label: Label = $CanvasLayer/Control/InrunUpgradesEnabled
	if InrunAbilityUpgradeEnabler.is_enabled:
		text_label.text = "In-Run Upgrades: True"
	else:
		text_label.text = "In-Run Upgrades: False"

func _on_start_button_pressed() -> void:
	GlobalSoundManager.play_button_click_sound()
	get_tree().change_scene_to_packed(character_select_scene)


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui_components/controls_menu/controls_menu.tscn")


func _on_load_button_pressed() -> void:
	pass # Replace with function body.
