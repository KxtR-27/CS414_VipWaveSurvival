extends Node


# array of BasePlayer instances
var players: Array[BasePlayer]


func _skill_tree_ready(all_skills: Dictionary) -> void:
	for skill: SkillComponent in all_skills.keys():
		print(skill)
