@abstract
class_name BaseCharacter
extends CharacterBody2D


signal health_changed(amount: float, negative: bool)


@export_group("")
@export var speed: float = 3000.0
@export var max_speed: float = 3000.0
@export var health: float = 100.0:
	set(new_health):
		health = new_health
		health_changed.emit()


func take_damage(amount: float) -> void:
	health_changed.emit(amount, true)
	pass # Replace with function body.
