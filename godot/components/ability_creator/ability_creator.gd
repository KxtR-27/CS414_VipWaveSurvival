extends Node2D

@export var caster : BasePlayer


func run_ability(ability : BaseAbility) -> void:
	match ability.ability_type:
		"aura":
			#create new node for the aura spell and child it under self
			var aura_spell_node : PackedScene = load("res://components/spells/aura_spell/aura_spell.tscn")
			var new_aura_spell : BaseSpell = aura_spell_node.instantiate()
			add_child(new_aura_spell)
			
			#run the spell with current ability parameters and caster
			new_aura_spell.run(ability, caster)
		"test":
			var test_spell_node : PackedScene = load("res://components/spells/test_spell/test_spell.tscn")
			var new_test_spell : BaseSpell = test_spell_node.instantiate()
			add_child(new_test_spell)
			
			new_test_spell.run(ability, caster)


func _on_base_player_ability_used(ability: BaseAbility) -> void:
	run_ability(ability)
