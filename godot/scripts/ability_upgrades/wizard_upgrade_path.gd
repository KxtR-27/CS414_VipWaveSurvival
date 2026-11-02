class_name UpgradePath extends Resource

var ability_upgrades: Dictionary[String, Dictionary] = {
	"Wizard One" : {
		2: preload("res://resources/ability_upgrades/wizard_one_upgrade1.tres"),
		3: preload("res://resources/ability_upgrades/wizard_one_upgrade2.tres"),
		4: preload("res://resources/ability_upgrades/wizard_one_upgrade3.tres"),
	},
	"Wizard Two" : {
		2: preload("res://resources/ability_upgrades/wizard_two_upgrade1.tres"),
		3: preload("res://resources/ability_upgrades/wizard_two_upgrade2.tres"),
		4: preload("res://resources/ability_upgrades/wizard_two_upgrade3.tres"),
	}
}

func apply_upgrade(hero: BasePlayer, level: int) -> void:
	if ability_upgrades["Wizard One"].keys().find(level) != -1:
		hero.override_abilities({
			"ABILITY_1" = ability_upgrades["Wizard One"][level],
			"ABILITY_2" = ability_upgrades["Wizard Two"][level]
		})
