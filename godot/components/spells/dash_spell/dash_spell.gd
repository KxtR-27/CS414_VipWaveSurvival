class_name DashSpell extends BaseSpell

@export var dash_hitbox: Area2D
@export var landing_hitbox: Area2D

@export var vfx: VFX

@onready var landing_lifetime_timer: Timer = $LandingLifetimeTimer

var dash_hits: Array = []
var landing_hits: Array = []
var spell_caster: BasePlayer
var dash_damage: int
var dash_healing: int
var landing_damage: int
var landing_healing: int
var duration: float
var distance: float

func run(ability: BaseAbility, caster: BasePlayer) -> void:
	print(ability)
	#remember who cast this spell
	spell_caster = caster
	
	#set ability values
	distance = ability.distance
	
	dash_damage = ability.dash_damage
	dash_healing = ability.dash_healing
	landing_damage = ability.landing_damage
	landing_healing = ability.landing_healing
	duration = ability.dash_time
	
	dash_hits.append(caster)
	landing_hits.append(caster)
	
	#get reticle direction and where to dash toward
	var reticle: CollisionShape2D = caster.hurtbox.get_node("Shape") as CollisionShape2D
	
	var direction: Vector2 = (reticle.global_position - caster.global_position).normalized()
	var landing_target: Vector2 = caster.global_position + (direction * distance)
	print(caster.global_position, reticle.global_position, direction)
	print(landing_target)
	
	#tween player's position to landing_target
	var tween: Tween = caster.create_tween()
	tween.tween_property(caster, "global_position", landing_target, duration)
	tween.finished.connect(func() -> void:
		landing_hitbox.monitoring = true
		landing_lifetime_timer.start()
		caster.can_move = true
	)
	
	#turn hitbox on and start spell
	caster.can_move = false
	dash_hitbox.monitoring = true
	tween.play()
	
	
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


func on_dash_hit(unit : BaseCharacter) -> void:
	resolve_hit(unit, dash_damage, dash_healing)


func on_landing_hit(unit : BaseCharacter) -> void:
	resolve_hit(unit, landing_damage, landing_healing)


func create_vfx(path_to_vfx: String) -> VFX:
	var vfx_scene : PackedScene = load(path_to_vfx)
	var new_vfx : Node2D = vfx_scene.instantiate()
	
	return new_vfx


func _on_dash_hitbox_body_entered(body: Node2D) -> void:
	if body is BaseCharacter and (dash_hits.find(body) == -1):
		dash_hits.append(body)
		on_dash_hit(body as BaseCharacter)


func _on_landing_hitbox_body_entered(body: Node2D) -> void:
	if body is BaseCharacter and (landing_hits.find(body) == -1):
		dash_hits.append(body)
		on_landing_hit(body as BaseCharacter)


func _on_landing_lifetime_timer_timeout() -> void:
	queue_free()
