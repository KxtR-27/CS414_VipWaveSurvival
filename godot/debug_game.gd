extends Node2D


@export var make_invincible: Array[BaseCharacter] = []


func _process(_delta: float) -> void:
	for character in make_invincible:
		var health_bar: HealthComponent
		
		if character is BaseVIP:
			health_bar = (character as BaseVIP)\
					.get_node("BarsContainer")\
					.get_node("HealthComponent") as HealthComponent
		elif character is BasePlayer or character is BaseEnemy:
			health_bar = (character as BaseCharacter)\
					.get_node("HealthComponent") as HealthComponent
			
		if health_bar:
			health_bar.current_health = health_bar.max_health
			health_bar.refresh()
