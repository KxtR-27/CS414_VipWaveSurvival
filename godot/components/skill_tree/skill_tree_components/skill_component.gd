extends Control

var active_color := Color("#00e667") as Color
var unlocked_color := Color("#00e2e6") as Color
var locked_color_panel := Color("007678ff") as Color
var locked_color_icon := Color("#696969") as Color

@onready var ability_panel := $VBoxContainer/CenterContainer/UpgradePanel as TextureRect
@onready var upgrade_icon_rect := $VBoxContainer/CenterContainer/UpgradeIcon as TextureRect
@onready var label := $VBoxContainer/Label as Label

enum SkillState {
	locked,
	unlocked,
	active
}

@export var current_state := SkillState.locked as SkillState
@export var upgrade_icon: Texture
@export var upgrade_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_icon_rect.texture = upgrade_icon
	label.text = upgrade_name
	
	match current_state:
		SkillState.locked:
			ability_panel.modulate = locked_color_panel
			upgrade_icon_rect.modulate = locked_color_icon
		SkillState.unlocked:
			ability_panel.modulate = unlocked_color
			upgrade_icon_rect.modulate = Color("#ffffff")
		SkillState.active:
			ability_panel.modulate = active_color


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed == true:
		if current_state == SkillState.locked:
			print("ability is locked, activate previous ability to unlock")
			return
		elif current_state == SkillState.unlocked:
			current_state = SkillState.active
			ability_panel.modulate = active_color
			return
		elif current_state == SkillState.active:
			print("Ability is already active")
			return
