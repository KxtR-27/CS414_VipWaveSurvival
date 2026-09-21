class_name TestSpell extends BaseSpell

func run(ability: BaseAbility, caster: BaseCharacter) -> void:
	print("test ability " + ability.ability_name + " run by " + caster.name)
