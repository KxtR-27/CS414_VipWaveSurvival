class_name CharacterStats extends Node

var damage: float
var max_health: float
var speed: float

func apply_stats() -> void:
	var hero: BasePlayer = get_parent()
	var health_component: HealthComponent = hero.get_node("HealthComponent")
	
	health_component.max_health = max_health
	hero.max_speed = speed
	hero.speed = speed
