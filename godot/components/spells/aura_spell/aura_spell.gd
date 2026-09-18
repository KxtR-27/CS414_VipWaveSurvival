class_name AuraSpell extends BaseSpell

@export var hitbox : Area2D
@export var remote_transform : RemoteTransform2D

@export var tick_timer : Timer
@export var lifetime_timer : Timer

var current_overlapping_targets : Array = []
var spell_caster : BasePlayer
var damage : int
var healing : int

func run(ability : BaseAbility, caster : BaseCharacter) -> void:
	#remember who cast this spell
	spell_caster = caster
	
	#set damage and healing numbers
	damage = ability.damage
	healing = ability.healing
	
	#make spell track player's location
	remote_transform.global_position = caster.global_position
	remote_transform.reparent(caster, true)
	remote_transform.remote_path = self.get_path()
	
	#add caster to observed targets
	current_overlapping_targets.append(caster)
	
	#turn hitbox on and start spell
	hitbox.monitoring = true
	tick_timer.start()
	lifetime_timer.start()


func on_tick() -> void:
	for target : BaseCharacter in current_overlapping_targets:
		if target.is_in_group("enemies"):
			target.health_changed.emit(damage, true)
		elif target.is_in_group("players") or target.is_in_group("vip"):
			target.health_changed.emit(healing, false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is BaseNPC and (current_overlapping_targets.find(body) == -1):
		current_overlapping_targets.append(body)


func _on_tick_timer_timeout() -> void:
	on_tick()


func _on_lifetime_timer_timeout() -> void:
	remote_transform.queue_free()
	queue_free()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is BaseNPC:
		current_overlapping_targets.erase(body)
