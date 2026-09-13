class_name HealthComponent extends Control

signal health_changed(amount_changed: float)
signal died

@export var max_health : float = 100.0
@onready var health_bar : ProgressBar = $HealthBar
var current_health : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	pass # Replace with function body.

func _on_health_changed(amount_changed: float, negative: bool) -> void:
	#can be used to heal or damage
	#negative numbers for damage dealt
	#positive numbers for healing
	if negative:
		current_health -= amount_changed
	else:
		current_health += amount_changed
	if current_health <= 0:
		died.emit()
	if current_health > max_health:
		current_health = max_health
	health_bar.value = current_health
	pass # Replace with function body.
