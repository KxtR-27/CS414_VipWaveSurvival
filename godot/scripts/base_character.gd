@abstract
class_name BaseCharacter
extends CharacterBody2D


signal health_changed(amount: float, negative: bool)


@export_group("")
@export var speed: float = 3000.0
@export var max_speed: float = 3000.0
@export var health: float = 100.0:
	set(new_health):
		var amount := absf(health - new_health)
		var negative := new_health < health
		health = new_health
		health_changed.emit(amount, negative)


# since this is an abstract class, using @onready nodes is not an option.
# thus, the only way to link them is with export variables supplied by an instance
@export_group("Optional Sounds")
@export var hurt_sound: AudioStreamPlayer
@export var attack_sound: AudioStreamPlayer


func take_damage(amount: float) -> void:
	health_changed.emit(amount, true)
	if hurt_sound:
		hurt_sound.play()
