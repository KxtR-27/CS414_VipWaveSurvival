class_name HasteEffect extends StatusEffect

func apply(_starting_stacks: int) -> void:
	effect_type = STATUS_EFFECT_TYPE.HASTE
	add_stacks(1)
	lifetime_timer.start(_starting_stacks)
	
	on_create()


func on_create() -> void:
	affected_unit.max_speed += 500.0
	affected_unit.speed += 500.0


func on_cleanse() -> void:
	affected_unit.max_speed -= 500.0
	affected_unit.speed -= 500.0
