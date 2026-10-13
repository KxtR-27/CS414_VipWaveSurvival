class_name ProjectileAbility extends BaseAbility

@export var projectile_speed: float
@export var distance: int

func get_spell_type() -> BaseSpell.SPELL_TYPE:
	return BaseSpell.SPELL_TYPE.PROJECTILE
