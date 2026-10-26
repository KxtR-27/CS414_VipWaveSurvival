class_name CharacterStats extends Node

@onready var hero: BasePlayer = get_parent()
@onready var health_component: HealthComponent = hero.get_node("HealthComponent")

var damage: float
var max_health: float
var speed: float


func apply_stats() -> void:
	health_component.max_health = max_health
	health_component.health_bar.max_value = max_health
	hero.max_speed = speed
	hero.speed = speed


func modify_stat(stat_name: String, amount: float) -> void:
	match stat_name:
		"damage":
			damage += amount
		"speed": 
			speed += amount
		"max_health":
			max_health += amount
			health_component.modify_max_health(amount)
	
	apply_stats()
