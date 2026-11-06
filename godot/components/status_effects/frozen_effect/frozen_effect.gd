class_name FrozenEffect extends StatusEffect

var old_speed: float

func apply(_starting_stacks: int) -> void:
	effect_type = STATUS_EFFECT_TYPE.FROZEN
	add_stacks(1)
	lifetime_timer.start(_starting_stacks)
	
	on_create()


func on_create() -> void:
	old_speed = affected_unit.max_speed
	affected_unit.max_speed = 0.0
	affected_unit.speed = 0.0


func on_cleanse() -> void:
	affected_unit.max_speed = old_speed
	affected_unit.speed = old_speed
