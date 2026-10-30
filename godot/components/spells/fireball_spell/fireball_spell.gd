class_name FireballSpell extends ProjectileSpell

@onready var tick_timer: Timer = $TickTimer
@onready var lifetime_timer: Timer = $LifetimeTimer
@onready var explosion: Area2D = $Explosion

var projectile_tween: Tween

var explosion_damage: int
var explosion_healing: int
var lifetime: float
var tick_interval: float
var tick_damage: int
var tick_healing: int


var units_in_area: Array[BaseCharacter] = []

func spawn_explosion() -> void:
	explosion.set_deferred("monitoring", true)
	projectile.set_deferred("monitoring", false)
	
	explosion.top_level = true
	explosion.global_transform = projectile.global_transform
	projectile.top_level = true
	projectile.global_transform = explosion.global_transform
	
	lifetime_timer.start()
	tick_timer.start()
	
	if vfx:
		vfx.anim_player.play("explosion")


func run(ability: BaseAbility, caster: BasePlayer) -> void:
	var fireball_ability := ability as FireballAbility
	
	#remember who cast this spell
	spell_caster = caster
	
	#set ability values
	distance = fireball_ability.distance
	explosion_damage = fireball_ability.explosion_damage
	explosion_healing = fireball_ability.explosion_healing
	projectile_damage = fireball_ability.damage
	projectile_healing = fireball_ability.healing
	tick_damage = fireball_ability.tick_damage
	tick_healing = fireball_ability.tick_healing
	lifetime_timer.wait_time = fireball_ability.lifetime
	tick_timer.wait_time = fireball_ability.tick_interval
	
	
	projectile_travel_time = fireball_ability.projectile_speed
	
	#get reticle direction and where to shoot projectile toward
	var reticle: CollisionShape2D = caster.hurtbox.get_node("Shape") as CollisionShape2D
	
	var direction: Vector2 = (reticle.global_position - caster.global_position).normalized()
	var landing_target: Vector2 = caster.global_position + (direction * distance)
	
	#tween projectile's position to landing_target
	var tween: Tween = projectile.create_tween()
	projectile_tween = tween
	projectile_tween.tween_property(projectile, "global_position", landing_target, projectile_travel_time)
	projectile_tween.finished.connect(
		func() -> void:
			spawn_explosion()
	)
	
	#turn hitbox on and start spell
	projectile.monitoring = true
	tween.play()
	
	
	if not ability.path_to_vfx.is_empty():
		var new_vfx: VFX = create_vfx(ability.path_to_vfx)
		if new_vfx:
			vfx = new_vfx
			projectile.add_child(new_vfx)
			new_vfx.play()


func resolve_hit(target: BaseCharacter, enemy_damage: int, ally_healing: int) -> void:
	if target.is_in_group("enemies") and enemy_damage > 0.0:
		target.health_changed.emit(enemy_damage, true)
	elif (target.is_in_group("players") or target.is_in_group("vip")) and ally_healing > 0.0:
		target.health_changed.emit(ally_healing, false)


func on_projectile_hit(unit: BaseCharacter) -> void:
	resolve_hit(unit, projectile_damage, projectile_healing)
	
	#for now, check if unit is enemy before triggering explosion
	if unit.is_in_group("enemies"):
		projectile_tween.kill()
		projectile_tween = null
		spawn_explosion()


func on_explosion_entered(unit: BaseCharacter) -> void:
	resolve_hit(unit, explosion_damage, explosion_healing)


func on_tick() -> void:
	for target: BaseCharacter in units_in_area:
		resolve_hit(target, tick_damage, tick_healing)
		if target.is_in_group("enemies"):
			(target.get_node("StatusEffectCreator") as StatusEffectCreator)\
				.apply_effect(StatusEffect.STATUS_EFFECT_TYPE.BURN, 1)


func create_vfx(path_to_vfx: String) -> VFX:
	var vfx_scene: PackedScene = load(path_to_vfx)
	var new_vfx: Node2D = vfx_scene.instantiate()
	
	return new_vfx


func _on_projectile_body_entered(body: Node2D) -> void:
		if body is BaseCharacter and (projectile_hits.find(body) == -1):
			projectile_hits.append(body)
			on_projectile_hit(body as BaseCharacter)


func _on_explosion_body_entered(body: Node2D) -> void:
	if body is BaseCharacter and (units_in_area.find(body) == -1):
			units_in_area.append(body)
			on_explosion_entered(body as BaseCharacter)


func _on_explosion_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		units_in_area.erase(body)


func _on_tick_timer_timeout() -> void:
	on_tick()


func _on_lifetime_timer_timeout() -> void:
	queue_free()
