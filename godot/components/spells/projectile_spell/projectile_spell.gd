class_name ProjectileSpell extends BaseSpell

@export var projectile: Area2D

@export var vfx: VFX

var projectile_hits: Array = []
var spell_caster: BasePlayer
var projectile_damage: int
var projectile_healing: int
var projectile_travel_time: float
var distance: float

func run(ability: BaseAbility, caster: BasePlayer) -> void:
	print(ability)
	#remember who cast this spell
	spell_caster = caster
	
	#set ability values
	distance = ability.distance
	projectile_damage = ability.damage
	projectile_healing = ability.healing
	
	projectile_travel_time = ability.projectile_speed
	
	#get reticle direction and where to dash toward
	var reticle: CollisionShape2D = caster.hurtbox.get_node("Shape") as CollisionShape2D
	
	var direction: Vector2 = (reticle.global_position - caster.global_position).normalized()
	var landing_target: Vector2 = caster.global_position + (direction * distance)
	print(caster.global_position, reticle.global_position, direction)
	print(landing_target)
	
	#tween player's position to landing_target
	var tween: Tween = projectile.create_tween()
	tween.tween_property(projectile, "global_position", landing_target, projectile_travel_time)
	tween.finished.connect(func() -> void:
		queue_free()
	)
	
	#turn hitbox on and start spell
	projectile.monitoring = true
	tween.play()
	
	
	if not ability.path_to_vfx.is_empty():
		var new_vfx: VFX = create_vfx(ability.path_to_vfx)
		if new_vfx:
			projectile.add_child(new_vfx)
			new_vfx.play()


func resolve_hit(target: BaseCharacter, enemy_damage: int, ally_healing: int) -> void:
	if target.is_in_group("enemies") and enemy_damage > 0.0:
		target.health_changed.emit(enemy_damage, true)
	elif (target.is_in_group("players") or target.is_in_group("vip")) and ally_healing > 0.0:
		target.health_changed.emit(ally_healing, false)


func on_projectile_hit(unit : BaseCharacter) -> void:
	resolve_hit(unit, projectile_damage, projectile_healing)


func create_vfx(path_to_vfx: String) -> VFX:
	var vfx_scene : PackedScene = load(path_to_vfx)
	var new_vfx : Node2D = vfx_scene.instantiate()
	
	return new_vfx


func _on_projectile_body_entered(body: Node2D) -> void:
		if body is BaseCharacter and (projectile_hits.find(body) == -1):
			projectile_hits.append(body)
			on_projectile_hit(body as BaseCharacter)
