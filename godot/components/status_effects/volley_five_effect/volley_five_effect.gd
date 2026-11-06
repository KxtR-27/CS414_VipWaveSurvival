class_name VolleyFiveEffect extends StatusEffect

func apply(_starting_stacks: int) -> void:
	effect_type = STATUS_EFFECT_TYPE.VOLLEY_FIVE
	add_stacks(1)
	lifetime_timer.start(_starting_stacks)
	
	on_create()


func on_create() -> void:
	var player_hero: BasePlayer = affected_unit as BasePlayer
	var ranged_attack: ProjectileAbility = player_hero.ranged_attack_ability as ProjectileAbility
	
	ranged_attack.projectile_count += 4


func on_cleanse() -> void:
	var player_hero: BasePlayer = affected_unit as BasePlayer
	var ranged_attack: ProjectileAbility = player_hero.ranged_attack_ability as ProjectileAbility
	
	ranged_attack.projectile_count -= 4
