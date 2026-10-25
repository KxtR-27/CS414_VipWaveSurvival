class_name SkillComponent extends Control

signal skill_activated(skill: SkillComponent)
signal skill_state_changed

var active_color := Color("#00e667") as Color
var unlocked_color := Color("#00e2e6") as Color
var locked_color_panel := Color("007678ff") as Color
var locked_color_icon := Color("#696969") as Color

@export var locked_by: Array[SkillComponent] = []

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
	
	if len(locked_by) == 0:
		current_state = SkillState.unlocked
	
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
	# Check if mouse button is pressed over the component
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed == true:
		# If currently locked, ability stays locked when clicked
		if current_state == SkillState.locked:
			print("ability is locked, activate previous ability to unlock")
			return
		# If unlocked, ability is activated when clicked
		elif current_state == SkillState.unlocked:
			current_state = SkillState.active
			skill_state_changed.emit()
			skill_activated.emit(self)
			return
		# If already activated, notify player that ability is already active
		elif current_state == SkillState.active:
			print("Ability is already active")
			return


func _on_skill_activated(skill: SkillComponent) -> void:
	for locked_by_child in locked_by:
		if skill == locked_by_child:
			current_state = SkillState.unlocked
			skill_state_changed.emit()


func _on_skill_state_changed() -> void:
	match current_state:
		SkillState.locked:
			ability_panel.modulate = locked_color_panel
			upgrade_icon_rect.modulate = locked_color_icon
		SkillState.unlocked:
			ability_panel.modulate = unlocked_color
			upgrade_icon_rect.modulate = Color("#ffffff")
		SkillState.active:
			ability_panel.modulate = active_color
