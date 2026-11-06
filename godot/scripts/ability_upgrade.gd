class_name AbilityUpgrade extends Resource

@export var modifications: Dictionary = {}

#Key: status effect to add (e.g. STATUS_EFFECT_TYPE.BURN), Value: how many stacks
@export var new_allied_status_effects: Dictionary[StatusEffect.STATUS_EFFECT_TYPE, int] = {}
@export var new_enemy_status_effects: Dictionary[StatusEffect.STATUS_EFFECT_TYPE, int] = {}
