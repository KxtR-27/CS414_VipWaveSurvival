class_name HealthComponent extends ProgressBar

signal died

@export var max_health: float = 100.0
var current_health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	max_value = max_health


func refresh() -> void:
	current_health = max_health
	max_value = max_health
	value = max_health


func modify_max_health(amount: float) -> void:
	var current_health_percentage: float = current_health / max_health
	
	max_health += amount
	current_health = max_health * current_health_percentage
	
	max_value = max_health
	value = current_health
	
	


#can be used to heal or damage
func _on_health_changed(amount_changed: float, negative: bool) -> void:
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
	self.value = current_health
