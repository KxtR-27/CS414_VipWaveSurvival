class_name BaseAbility extends Resource

@export var ability_name: String
@export var lifetime: float
@export var tick_interval: float
@export var damage: int
@export var healing: int
@export var is_top_level: bool
@export var follows_reticle: bool
@export var path_to_vfx: String
@export var allied_status_effects: Dictionary[StatusEffect.STATUS_EFFECT_TYPE, int] = {}
@export var enemy_status_effects: Dictionary[StatusEffect.STATUS_EFFECT_TYPE, int] = {}

func get_spell_type() -> BaseSpell.SPELL_TYPE:
	return BaseSpell.SPELL_TYPE.DASH
