class_name FireballAbility extends BaseAbility

@export var explosion_damage: int
@export var explosion_healing: int
@export var projectile_speed: float
@export var distance: int
@export var tick_damage: int
@export var tick_healing: int


func get_spell_type() -> BaseSpell.SPELL_TYPE:
	return BaseSpell.SPELL_TYPE.FIREBALL
