class_name BaseVIP
extends BaseNPC

signal started_following
signal stopped_following

@export var follow_command_range: float = 400.0
@export var can_follow : bool = true
@export_range(0.0,100.0) var follow_chance : float = 100.0


func request_to_follow(player: BasePlayer) -> void:
	if can_follow:
		var roll_to_follow : float = randf_range(0.0, 100.0)
		if roll_to_follow <= follow_chance:
			target_to_follow = player
			started_following.emit()
		else:
			print("the vip has ignored your command (roll: ", roll_to_follow, ")")


func request_to_stop_following(player: BasePlayer) -> void:
	if target_to_follow == player:
		target_to_follow = null
		stopped_following.emit()


func _on_target_scanned(character: BaseCharacter, flee: bool) -> void:
	if flee: target_to_flee_from = character


func _on_health_component_died() -> void:
	GlobalEvents.game_lost.emit()
	self.queue_free()
	pass # Replace with function body.
