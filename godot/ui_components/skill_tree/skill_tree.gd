class_name SkillTree extends Control

@onready var root_ability: SkillComponent = $UpgradeNodes/VBoxContainer/CenterContainer/Dash1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root_ability.grab_focus.call_deferred()
	pass
