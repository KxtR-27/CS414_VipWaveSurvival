@abstract
class_name BaseCharacter
extends CharacterBody2D


signal health_changed(amount: float, negative: bool)


@export_group("")
@export var speed: float = 3000.0
@export var health: float = 100.0:
	set(new_health):
		health = new_health
		health_changed.emit()

@export_group("Components")
@export var health_component: HealthComponent
@export var damage_component: DamageComponent
