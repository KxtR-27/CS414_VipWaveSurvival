extends Control

var active_color := Color("#00e667") as Color
var unlocked_color := Color("#00e2e6") as Color
var locked_color := Color("007678ff") as Color
@onready var ability_panel := $TextureRect as TextureRect

enum SkillState {
	locked,
	unlocked,
	active
}

@export var current_state := SkillState.locked as SkillState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match current_state:
		SkillState.locked:
			ability_panel.modulate = locked_color
		SkillState.unlocked:
			ability_panel.modulate = unlocked_color
		SkillState.active:
			ability_panel.modulate = active_color
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed == true:
		if event is InputEventMouseMotion and (event as InputEventMouseMotion).is_canceled():
			return
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
