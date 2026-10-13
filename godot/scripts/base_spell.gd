@abstract
class_name BaseSpell 
extends Node2D

enum SPELL_TYPE {
	DASH,
	PROJECTILE,
	AREA
}

@abstract
func run(ability: BaseAbility, caster: BasePlayer) -> void
