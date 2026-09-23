class_name AimableHurtbox
extends Area2D


var targets_in_hurtbox: Array[BaseCharacter] = []


func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		targets_in_hurtbox.append(body as BaseCharacter)


func _on_body_exited(body: Node2D) -> void:
	if body in targets_in_hurtbox:
		targets_in_hurtbox.erase(body)


func aim_in_dir(direction: Vector2) -> void:
	self.rotation = direction.angle()


func aim_at_body(body: Node2D) -> void:
	self.rotation = self.global_position.angle_to(body.global_position)
