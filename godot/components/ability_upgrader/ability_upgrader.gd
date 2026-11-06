class_name AbilityUpgrader extends Node

const MAX_LEVEL: int = 3

@export var ability_upgrade_paths: Dictionary[BaseAbility, AbilityUpgradePath]
@export var ability_levels: Dictionary[BaseAbility, int]


func upgrade_ability(ability: BaseAbility) -> void:
	if ability_levels.has(ability):
		var level: int = ability_levels[ability]
		
		if (level + 1) <= MAX_LEVEL:
			level += 1
			ability_levels[ability] = level
			
			var upgrade_path: AbilityUpgradePath = ability_upgrade_paths[ability]
			var upgrade: AbilityUpgrade = upgrade_path.upgrades[level]
			
			for modification: String in upgrade.modifications.keys():
				ability.set(modification, upgrade.modifications[modification])
			
			if not upgrade.new_allied_status_effects.is_empty(): 
				ability.allied_status_effects = upgrade.new_allied_status_effects
			
			if not upgrade.new_enemy_status_effects.is_empty(): 
				ability.enemy_status_effects = upgrade.new_enemy_status_effects


func upgrade_all_abilities() -> void:
	for ability: BaseAbility in ability_upgrade_paths.keys():
		upgrade_ability(ability)


func assign_paths(paths: Dictionary[BaseAbility, AbilityUpgradePath]) -> void:
	ability_upgrade_paths = paths
	
	ability_levels.clear()
	for ability: BaseAbility in ability_upgrade_paths.keys():
		ability_levels[ability] = 0
