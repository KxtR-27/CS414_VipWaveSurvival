class_name BaseEnemy
extends BaseNPC

@onready var target_polling_timer := $TargetPollingTimer as Timer
@onready var attack_cooldown := $AttackCooldown as Timer
@onready var attack_hurtbox := $AimableAttackHurtbox as AimableHurtbox
@onready var attack_on_cooldown := false as bool

func _ready() -> void:
	# return if target already exists
	if target_to_follow: return
	# otherwise, check for closest
	_poll_for_closest_target()
	# if we still didn't find one, poll automatically until we do
	if not target_to_follow:
		target_polling_timer.start()


func _process(_delta: float) -> void:
	if attack_on_cooldown:
		attack_hurtbox.monitoring = false


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if target_to_follow:
		attack_hurtbox.aim_at_body(target_to_follow)


## sorts targets by their closeness to this enemy
func _sort_by_closeness(a: Node2D, b: Node2D) -> bool:
	var a_dist_from_self: float = self.global_position.distance_to(a.global_position)
	var b_dist_from_self: float = self.global_position.distance_to(b.global_position)
	return a_dist_from_self < b_dist_from_self


## checks the [code]targets[/code] group, sorts by the closest target,
## and picks that target to move toward.
func _poll_for_closest_target() -> void:
	# run check for closest target
	var targets := get_tree().get_nodes_in_group("enemy_targets").slice(0) as Array[Node]
	if targets.is_empty(): return
	
	# sort by closeness
	targets.sort_custom(_sort_by_closeness)
	var closest_target := targets[0] as Node2D
	
	# stop polling and update target if found
	if closest_target:
		target_polling_timer.stop()
		target_to_follow = closest_target


## poll for target at regular interval set by [code]target_polling_timer[/code]
func _on_target_polling_timer_timeout() -> void:
	_poll_for_closest_target() 


func _on_health_component_died() -> void:
	self.queue_free()


### change targets when a valid target enters TargetScanner
func _on_target_scanned(character: BaseCharacter, flee: bool) -> void:
	if flee:
		target_to_flee_from = character
	else:
		target_to_follow = character


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is BaseCharacter and body.is_in_group("enemy_targets"):
		var character := body as BaseCharacter
		character.take_damage(10.0)
		attack_cooldown.start()
		attack_on_cooldown = true


func _on_attack_cooldown_timeout() -> void:
	attack_on_cooldown = false
	attack_hurtbox.monitoring = true
