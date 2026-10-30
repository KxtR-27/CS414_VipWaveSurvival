class_name StatusEffectCreator extends Node

const STATUS_EFFECT_LOOKUP: Dictionary[StatusEffect.STATUS_EFFECT_TYPE, PackedScene] = {
	StatusEffect.STATUS_EFFECT_TYPE.BURN: preload("res://components/status_effects/burn_effect/burn_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.REGEN: preload("res://components/status_effects/regen_effect/regen_effect.tscn")
}

var current_status_effects: Array[StatusEffect] = []

func apply_effect(status_effect_type: StatusEffect.STATUS_EFFECT_TYPE, stacks: int) -> void:
	var status_effect: StatusEffect = find_status_effect(status_effect_type)
	if status_effect:
		#status effect already exists - just add stacks
		status_effect.add_stacks(stacks)
	else:
		#create new status effect, add it as child and track in current_status_effects
		var new_status_effect := STATUS_EFFECT_LOOKUP[status_effect_type].instantiate()
		status_effect = new_status_effect
		
		add_child(status_effect)
		current_status_effects.append(status_effect)
		
		#start status effect and connect finished signal to freeing the effect
		status_effect.affected_unit = get_parent()
		status_effect.apply(stacks)
		
		status_effect.finished.connect(
			func() -> void: 
				current_status_effects.erase(status_effect)
				status_effect.queue_free()
		)


func find_status_effect(status_effect_type: StatusEffect.STATUS_EFFECT_TYPE) -> StatusEffect:
	for effect in current_status_effects:
		if effect.effect_type == status_effect_type:
			return effect
	
	return null
