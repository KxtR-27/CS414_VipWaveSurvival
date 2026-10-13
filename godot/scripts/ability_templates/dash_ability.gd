class_name DashAbility extends BaseAbility

@export var dash_time: float
@export var dash_damage: int
@export var dash_healing: int
@export var landing_damage: int
@export var landing_healing: int
@export var distance: int

func get_spell_type() -> BaseSpell.SPELL_TYPE:
	return BaseSpell.SPELL_TYPE.DASH
