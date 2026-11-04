@tool
class_name SkillComponent 
extends Control


signal skill_activated(skill: SkillComponent)
signal skill_state_changed

enum SkillState {
	locked,
	unlocked,
	active
}

const ACTIVE_COLOR := Color("#00e667")
const UNLOCKED_COLOR := Color("#00e2e6")
const LOCKED_PANEL_COLOR := Color("007678ff")
const LOCKED_ICON_COLOR := Color("#696969")


@export var locked_by: Array[SkillComponent] = []

@export var current_state := SkillState.locked as SkillState
@export var upgrade_icon: Texture
@export var upgrade_name: String

@onready var _ability_panel := $CenterContainer/UpgradePanel as TextureRect
@onready var _upgrade_icon_rect := $CenterContainer/UpgradeIcon as TextureRect
@onready var _label := $Label as Label


func _ready() -> void:
	update_visuals()


func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
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
	update_visuals()


func update_visuals() -> void:
	_upgrade_icon_rect.texture = upgrade_icon
	_label.text = upgrade_name
	
	if len(locked_by) == 0:
		current_state = SkillState.unlocked
	
	match current_state:
		SkillState.locked:
			_ability_panel.modulate = LOCKED_PANEL_COLOR
			_upgrade_icon_rect.modulate = LOCKED_ICON_COLOR
		SkillState.unlocked:
			_ability_panel.modulate = UNLOCKED_COLOR
			_upgrade_icon_rect.modulate = Color("#ffffff")
		SkillState.active:
			_ability_panel.modulate = ACTIVE_COLOR
