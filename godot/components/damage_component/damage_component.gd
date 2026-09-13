class_name DamageComponent extends Node

func deal_damage(amount: float, body: BaseCharacter) -> void:
	if body.health_component:
		body.health_component.health_changed.emit(amount, true)
	pass # Replace with function body.
