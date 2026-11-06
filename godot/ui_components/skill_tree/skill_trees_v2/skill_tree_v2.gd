@tool
class_name SkillTreeV2
extends VBoxContainer


const SKILL_COMPONENT_SCENE: PackedScene = preload("res://ui_components/skill_tree/skill_tree_components/skill_component.tscn")
const ROOT_SKILL_CONTAINER_NAME: String = "RootSkillContainer"


@export var title: String:
	set(new_title):
		title = new_title
		if title_label:
			title_label.text = title

@export var root_skill: SkillResource

@export_tool_button("Generate Skill Tree", "Paint") var gen_tree_btn := \
	func() -> void: generate_tree()

@export_tool_button("Clear Generated Tree", "Remove") var clear_tree_btn := \
	func() -> void: clear_generated_tree()


@onready var title_label := $Title as Label
@onready var template_skill_container := $TemplateSkillContainer as VBoxContainer
@onready var template_unlockables_row := $TemplateSkillContainer/TemplateUnlockablesRow as HBoxContainer


func generate_tree() -> void:
	if not root_skill:
		push_error("Skill Tree does not have a root skill.")
		return
	
	clear_generated_tree()
	_recursively_generate_skill_tree(root_skill, self, true)
	template_skill_container.visible = false


func clear_generated_tree() -> void:
	template_skill_container.visible = true
	if self.has_node(ROOT_SKILL_CONTAINER_NAME):
		self.remove_child(self.get_node(ROOT_SKILL_CONTAINER_NAME))
		# shrink manually
		self.size.x = -1
		self.size.x += 100
		self.size.y = -1


func _recursively_generate_skill_tree(skill: SkillResource, add_to: Node, is_root: bool) -> void:
	var skill_container := _dupe_skill_container(skill, add_to, is_root)
	_add_new_skill_component(skill, skill_container)
	var unlockables_row := _dupe_unlockables_row(skill, skill_container)
	
	for unlockable_skill in skill.unlockable_skills:
		if unlockable_skill:
			_recursively_generate_skill_tree(unlockable_skill, unlockables_row, false)



func _dupe_skill_container(skill: SkillResource, add_to: Node, is_root: bool = false) -> VBoxContainer:
	# clean up duplicated conatiner
	var container := template_skill_container.duplicate() as VBoxContainer
	# manually shrink
	container.size.y = -1
	add_to.add_child(container)
	container.owner = get_tree().edited_scene_root
	container.visible = true
	
	for child in container.get_children():
		child.queue_free()
	
	# important that the root container has this specific name
	var container_name := \
			ROOT_SKILL_CONTAINER_NAME if is_root \
			else ("%sSkillContainer" % skill.ability.ability_name.replace(" ", ""))
			
	container.name = container_name
	
	return container


func _dupe_unlockables_row(skill: SkillResource, add_to: Node) -> HBoxContainer:
	var row := template_unlockables_row.duplicate() as HBoxContainer
	add_to.add_child(row)
	row.owner = get_tree().edited_scene_root
	row.name = "%sUnlockablesRow" % skill.ability.ability_name
	
	for child in row.get_children():
		child.queue_free()
	
	return row


func _add_new_skill_component(skill: SkillResource, add_to: Node) -> SkillComponent:
	var skill_component := SKILL_COMPONENT_SCENE.instantiate() as SkillComponent
	skill_component.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	skill_component.upgrade_name = skill.ability.ability_name
	skill_component.upgrade_icon = skill.icon
	skill_component.current_state = \
			SkillComponent.SkillState.unlocked if skill.unlocked \
			else SkillComponent.SkillState.locked
	
	add_to.add_child(skill_component)
	skill_component.owner = get_tree().edited_scene_root
	skill_component.name = "%sSkill" % skill.ability.ability_name
	skill_component.update_visuals()
	
	return skill_component
