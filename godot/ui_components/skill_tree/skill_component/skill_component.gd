@tool
class_name SkillComponent 
extends Control


signal skill_activated

const SkillState = SkillResource.SkillState

const ACTIVE_COLOR := Color("#00e667")
const UNLOCKED_COLOR := Color("#00e2e6")
const LOCKED_PANEL_COLOR := Color("007678ff")
const LOCKED_ICON_COLOR := Color("#696969")


@export var skill: SkillResource:
	set(new_skill):
		# disconnect from old skill
		if skill and skill.changed.is_connected(update_visuals.call_deferred):
			skill.changed.disconnect(update_visuals.call_deferred)
		# connect to new skill
		skill = new_skill
		if new_skill and not skill.changed.is_connected(update_visuals.call_deferred):
			skill.changed.connect(update_visuals.call_deferred)

@export_tool_button("Update", "Reload") var update_visuals_btn := \
	func() -> void: update_visuals.call_deferred()

@onready var _ability_panel := $CenterContainer/UpgradePanel as TextureRect
@onready var _upgrade_icon_rect := $CenterContainer/UpgradeIcon as TextureRect
@onready var _label := $Label as Label


func _ready() -> void:
	update_visuals.call_deferred()


func _gui_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	# Check if mouse button is pressed over the component
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed == true:
		match (skill.state):
			# If currently locked, ability stays locked when clicked
			SkillState.locked:
				print("ability is locked, activate previous ability to unlock")
			# If unlocked, ability is activated when clicked
			SkillState.unlocked:
				skill.state = SkillState.active
				skill_activated.emit()
			# If already activated, notify player that ability is already active
			SkillState.active:
				print("Ability is already active")


func update_visuals() -> void:
	if !skill:
		push_warning(
			"update_visuals() was called but there is no skill to update from.\nSelf: %s" % self
		)
		return
	
	if _upgrade_icon_rect:
		_upgrade_icon_rect.texture = skill.icon
	if _label:
		_label.text = skill.ability.ability_name
	
	if _ability_panel:
		match skill.state:
			SkillState.locked:
				_ability_panel.modulate = LOCKED_PANEL_COLOR
				_upgrade_icon_rect.modulate = LOCKED_ICON_COLOR
			SkillState.unlocked:
				_ability_panel.modulate = UNLOCKED_COLOR
				_upgrade_icon_rect.modulate = Color("#ffffff")
			SkillState.active:
				_ability_panel.modulate = ACTIVE_COLOR
