class_name RegenEffect extends StatusEffect

func apply(_starting_stacks: int) -> void:
	effect_type = STATUS_EFFECT_TYPE.REGEN
	add_stacks(_starting_stacks)
	tick_timer.start()


func on_tick() -> void:
	affected_unit.health_changed.emit(num_stacks, false)
	remove_stacks(1)
