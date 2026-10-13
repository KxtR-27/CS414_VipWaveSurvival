extends Node2D

const SPELL_LOOKUP: Dictionary[BaseSpell.SPELL_TYPE, PackedScene] = {
	BaseSpell.SPELL_TYPE.AREA : preload("res://components/spells/area_spell/area_spell.tscn"),
	BaseSpell.SPELL_TYPE.DASH : preload("res://components/spells/dash_spell/dash_spell.tscn"),
	BaseSpell.SPELL_TYPE.PROJECTILE : preload("res://components/spells/projectile_spell/projectile_spell.tscn")
}

@export var caster: BasePlayer

@onready var ability_sound := $AbilitySound as AudioStreamPlayer


func run_ability(ability: BaseAbility) -> void:
	#create new node for the spell and child it under self
	var spell_type := ability.get_spell_type()
	var spell := SPELL_LOOKUP[spell_type].instantiate() as BaseSpell
	add_child(spell)
	
	#run the spell with current ability parameters and caster
	spell.run(ability, caster)
	
	ability_sound.play()


func _on_base_player_ability_used(ability: BaseAbility) -> void:
	run_ability(ability)
