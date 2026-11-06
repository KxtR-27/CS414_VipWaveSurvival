class_name VulnerableEffect extends StatusEffect

var has_already_applied: bool = false

func apply(_starting_stacks: int) -> void:
	effect_type = STATUS_EFFECT_TYPE.VULNERABLE
	add_stacks(1)
	lifetime_timer.start(_starting_stacks)


func on_damage_taken(damage: float) -> void:
	if damage > 0.0 and not has_already_applied:
		has_already_applied = true
		
		var extra_damage: float = damage * 0.15 #15% extra damage
		affected_unit.take_damage(extra_damage)
		
		finished.emit()
