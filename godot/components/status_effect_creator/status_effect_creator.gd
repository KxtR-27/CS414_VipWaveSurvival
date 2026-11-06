class_name StatusEffectCreator extends Node2D

const STATUS_EFFECT_LOOKUP: Dictionary[StatusEffect.STATUS_EFFECT_TYPE, PackedScene] = {
	StatusEffect.STATUS_EFFECT_TYPE.BURN: preload("res://components/status_effects/burn_effect/burn_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.REGEN: preload("res://components/status_effects/regen_effect/regen_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.FROZEN: preload("res://components/status_effects/frozen_effect/frozen_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.VOLLEY_THREE: preload("res://components/status_effects/volley_three_effect/volley_three_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.VOLLEY_FIVE: preload("res://components/status_effects/volley_five_effect/volley_five_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.EXTRA_RANGE: preload("res://components/status_effects/extra_range_effect/extra_range_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.HASTE: preload("res://components/status_effects/haste_effect/haste_effect.tscn"),
	StatusEffect.STATUS_EFFECT_TYPE.VULNERABLE: preload("res://components/status_effects/vulnerable_effect/vulnerable_effect.tscn")
}

@onready var labels_vbox: VBoxContainer = $StatusEffectLabels/LabelsVBox

var current_status_effects: Array[StatusEffect] = []
var current_status_effect_labels: Dictionary[StatusEffect, Label] = {}

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
		
		#create label for this status effect
		var new_label: Label = create_status_effect_label(status_effect)
		current_status_effect_labels[status_effect] = new_label
		labels_vbox.add_child(new_label)
		
		var health_changed_connection := func(amount: float, negative: bool) -> void:
			if negative and is_instance_valid(status_effect):
					status_effect.on_damage_taken(amount)
					
		status_effect.affected_unit.health_changed.connect(health_changed_connection)
		
		status_effect.finished.connect(
			func() -> void:
				status_effect.affected_unit.health_changed.disconnect(health_changed_connection)
				current_status_effect_labels[status_effect].queue_free()
				current_status_effect_labels.erase(status_effect)
				
				current_status_effects.erase(status_effect)
				status_effect.queue_free()
		)


func find_status_effect(status_effect_type: StatusEffect.STATUS_EFFECT_TYPE) -> StatusEffect:
	for effect in current_status_effects:
		if effect.effect_type == status_effect_type:
			return effect
	
	return null


func create_status_effect_label(status_effect: StatusEffect) -> Label:
	var new_label: Label = Label.new()
	new_label.text = status_effect.status_name
	new_label.modulate = status_effect.status_effect_label_color
	new_label.add_theme_constant_override("outline_size", 4)
	new_label.add_theme_font_size_override("font_size", 16)
	new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	return new_label
