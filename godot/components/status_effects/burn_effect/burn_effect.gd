class_name BurnEffect extends StatusEffect

func apply(_starting_stacks: int) -> void:
	effect_type = STATUS_EFFECT_TYPE.BURN
	add_stacks(_starting_stacks)
	tick_timer.start()


func on_tick() -> void:
	affected_unit.take_damage(num_stacks)
	remove_stacks(1)
