extends Node2D

@onready var start_button := $CanvasLayer/StartButton as Button
@onready var container := $CanvasLayer/HBoxContainer as HBoxContainer

var skill_trees: Dictionary[String, PackedScene] = {
	"wizard": preload("res://ui_components/skill_tree/character_skill_trees/wizard_skill_tree.tscn"),
	"swordsman": preload("res://ui_components/skill_tree/character_skill_trees/swordsman_skill_tree.tscn"),
	"knight": preload("res://ui_components/skill_tree/character_skill_trees/knight_skill_tree.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.grab_focus.call_deferred()
	
	for hero_name: String in GlobalPlayerManager.players.keys():
		var skill_tree: Control
		match hero_name:
			"wizard":
				skill_tree = skill_trees[hero_name].instantiate()
			"swordsman":
				skill_tree = skill_trees[hero_name].instantiate()
			"knight":
				skill_tree = skill_trees[hero_name].instantiate()
		
		container.add_child(skill_tree)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui_components/character_select_screen/character_select_screen.tscn")
