class_name AreaAbility extends BaseAbility

@export var tick_damage: int
@export var tick_healing: int

func get_spell_type() -> BaseSpell.SPELL_TYPE:
	return BaseSpell.SPELL_TYPE.AREA
