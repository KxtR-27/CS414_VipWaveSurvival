extends Node


# array of BasePlayer instances
var players: Array[BasePlayer]


func skill_tree_ready(all_skills: Dictionary[SkillComponent, SkillResource]) -> void:
	for skill_component: SkillComponent in all_skills.keys():
		if not skill_component.skill_activated.is_connected(_print_hi):
			skill_component.skill_activated.connect(_print_hi)
		


func _print_hi() -> void:
	print("hi")
