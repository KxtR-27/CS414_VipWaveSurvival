class_name AuraSpell extends BaseSpell

@export var hitbox: Area2D

@export var tick_timer: Timer
@export var lifetime_timer: Timer

#If disabled, the ability will both move with and be centered on the player
@export var is_top_level: bool

@export var vfx: VFX

var current_overlapping_targets: Array = []
var spell_caster: BasePlayer
var damage: int
var healing: int
var tick_damage: int
var tick_healing: int
var lifetime: float
var tick_interval: float
var remote_transform2d: RemoteTransform2D

func run(ability: BaseAbility, caster: BasePlayer) -> void:
	#remember who cast this spell
	spell_caster = caster
	
	#set damage and healing numbers, lifetime, and tick interval
	damage = ability.damage
	healing = ability.healing
	tick_damage = ability.tick_damage
	tick_healing = ability.tick_healing
	lifetime_timer.wait_time = ability.lifetime
	tick_timer.wait_time = ability.tick_interval
	
	#if top-level is enabled, place spell on caster's reticle
	if ability.is_top_level and caster is BasePlayer:
		top_level = true
		global_position = caster.global_position
	#otherwise, add caster to observed targets
	else:
		current_overlapping_targets.append(caster)
	
	#does the ability follow the reticle?
	if ability.follows_reticle:
		var reticle := caster.hurtbox.get_node("Shape") as CollisionShape2D
		global_position = reticle.global_position
		
		var new_remote_transform2d: RemoteTransform2D = RemoteTransform2D.new()
		remote_transform2d = new_remote_transform2d
		reticle.add_child(remote_transform2d)
		
		remote_transform2d.remote_path = get_path()
	
	#turn hitbox on and start spell
	hitbox.monitoring = true
	tick_timer.start()
	lifetime_timer.start()
	
	if not ability.path_to_vfx.is_empty():
		var new_vfx: VFX = create_vfx(ability.path_to_vfx)
		if new_vfx:
			add_child(new_vfx)
			new_vfx.play()


func resolve_hit(target: BaseCharacter, enemy_damage: int, ally_healing: int) -> void:
	if target.is_in_group("enemies") and enemy_damage > 0.0:
		target.health_changed.emit(enemy_damage, true)
	elif (target.is_in_group("players") or target.is_in_group("vip")) and ally_healing > 0.0:
		target.health_changed.emit(ally_healing, false)


func on_entered(unit : BaseCharacter) -> void:
	resolve_hit(unit, damage, healing)


func on_tick() -> void:
	for target: BaseCharacter in current_overlapping_targets:
		resolve_hit(target, tick_damage, tick_healing)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is BaseCharacter and (current_overlapping_targets.find(body) == -1):
		current_overlapping_targets.append(body)
		on_entered(body as BaseCharacter)


func _on_tick_timer_timeout() -> void:
	on_tick()


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		current_overlapping_targets.erase(body)


func create_vfx(path_to_vfx: String) -> VFX:
	var vfx_scene : PackedScene = load(path_to_vfx)
	var new_vfx : Node2D = vfx_scene.instantiate()
	
	return new_vfx


func _on_tree_exiting() -> void:
	if remote_transform2d:
		remote_transform2d.queue_free()
