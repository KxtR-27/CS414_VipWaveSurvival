@tool
class_name SkillResource
extends Resource


enum SkillState {
	locked,
	unlocked,
	active
}


@export var ability: BaseAbility:
	set(new_ability):
		ability = new_ability
		emit_changed()

@export var icon: Texture2D:
	set(new_icon):
		icon = new_icon
		emit_changed()

@export var state: SkillState:
	set(new_state):
		state = new_state
		if state == SkillState.active:
			if unlockable_skill_one and unlockable_skill_one.state == SkillState.locked:
				unlockable_skill_one.state = SkillState.unlocked
				print("unlocked skill %s" % unlockable_skill_one)
			elif unlockable_skill_one:
				print("did not unlock skill %s because skill is %s" % [
						unlockable_skill_one.ability.ability_name, unlockable_skill_one.state
				])
			else:
				print("did not unlock skill one because there is no skill")
			
			if unlockable_skill_two and unlockable_skill_two.state == SkillState.locked:
				unlockable_skill_two.state = SkillState.unlocked
				print("unlocked skill %s" % unlockable_skill_two)
			elif unlockable_skill_two:
				print("did not unlock skill %s because skill is %s" % [
						unlockable_skill_two.ability.ability_name, unlockable_skill_two.state
				])
			else:
				print("did not unlock skill two because there is no skill")
			
		emit_changed()

@export var unlockable_skill_one: SkillResource:
	set(new_unlockable):
		unlockable_skill_one = new_unlockable
		emit_changed()

@export var unlockable_skill_two: SkillResource:
	set(new_unlockable):
		unlockable_skill_two = new_unlockable
		emit_changed()
