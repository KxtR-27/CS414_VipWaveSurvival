class_name TargetedAbility extends BaseAbility

@export var targets_self: bool
@export var targets_allies: bool
@export var targets_vip: bool
@export var targets_enemies: bool
@export var tick_damage: int
@export var tick_healing: int


func get_spell_type() -> BaseSpell.SPELL_TYPE:
	return BaseSpell.SPELL_TYPE.TARGETED
