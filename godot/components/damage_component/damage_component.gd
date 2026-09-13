class_name DamageComponent extends Node

func deal_damage(amount: float, body: BaseCharacter) -> void:
	body.health_changed.emit(amount, true)
	pass # Replace with function body.
