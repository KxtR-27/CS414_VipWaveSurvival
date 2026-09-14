class_name BaseVIP
extends BaseNPC

@export var follow_command_range: float = 400.0


func request_to_follow(player: BasePlayer) -> void:
	target_to_follow = player


func request_to_stop_following(player: BasePlayer) -> void:
	if target_to_follow == player:
		target_to_follow = null


func _on_target_scanned(character: BaseCharacter, flee: bool) -> void:
	if flee: target_to_flee_from = character
