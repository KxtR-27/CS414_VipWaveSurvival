class_name BaseVIP
extends BaseNPC

signal started_following
signal stopped_following

@export var follow_command_range: float = 400.0
@export var can_follow: bool = true
@export_range(0.0,100.0) var follow_chance: float = 100.0

var panicking: bool = false
@export var panic_speed: float = 15000


func _physics_process(delta: float) -> void:
	if not panicking:
		super._physics_process(delta)
	if panicking:
		var direction := self.global_position.direction_to(target_to_follow.global_position)
		if is_following():
			velocity = panic_speed * direction * delta
			move_and_slide()
		else:
			stop_panicking()


func panic() -> void:
	panicking = true
	(get_node("TargetScanner") as TargetScanner).monitoring = false
	var players: Array[Node] = get_tree().get_nodes_in_group("players").slice(0)
	target_to_follow = players.pick_random()


func stop_panicking() -> void:
	panicking = false
	(get_node("TargetScanner") as TargetScanner).monitoring = true
	target_to_follow = null


func request_to_follow(player: BasePlayer) -> void:
	if self.target_to_follow == player:
		print("the vip is already following this player!")
	elif can_follow:
		var roll_to_follow: float = randf_range(0.0, 100.0)
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
	GlobalEvents.lose_game()
	self.queue_free()
