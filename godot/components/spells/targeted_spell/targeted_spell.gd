class_name TargetedSpell extends BaseSpell

@export var vfx: VFX

@onready var tick_timer: Timer = $TickTimer
@onready var lifetime_timer: Timer = $LifetimeTimer

var spell_caster: BasePlayer
var damage: int
var healing: int
var tick_damage: int
var tick_healing: int

var targets_self: bool
var targets_allies: bool
var targets_vip: bool
var targets_enemies: bool

var current_targets: Array[BaseCharacter] = []

func run(ability: BaseAbility, caster: BasePlayer) -> void:
	var targeted_ability := ability as TargetedAbility
	
	#remember who cast this spell
	spell_caster = caster
	
	#set damage and healing numbers, lifetime, and tick interval
	damage = targeted_ability.damage
	healing = targeted_ability.healing
	tick_damage = targeted_ability.tick_damage
	tick_healing = targeted_ability.tick_healing
	
	targets_self = targeted_ability.targets_self
	targets_allies = targeted_ability.targets_allies
	targets_vip = targeted_ability.targets_vip
	targets_enemies = targeted_ability.targets_enemies
	
	
	if not ability.path_to_vfx.is_empty():
		var new_vfx: VFX = create_vfx(ability.path_to_vfx)
		if new_vfx:
			add_child(new_vfx)
			new_vfx.play()
	
	if targets_self:
		current_targets.append(spell_caster)
	if targets_allies:
		for ally: BasePlayer in get_tree().get_nodes_in_group("players"):
			if ally != spell_caster:
				current_targets.append(ally)
	if targets_enemies:
		for enemy: BaseEnemy in get_tree().get_nodes_in_group("enemies"):
			current_targets.append(enemy)
	if targets_vip:
		var vip: BaseVIP = get_tree().get_first_node_in_group("vip")
		current_targets.append(vip)
	
	for target in current_targets:
		resolve_hit(target, damage, healing)
	
	tick_timer.start()
	lifetime_timer.start()


func on_tick() -> void:
	for target in current_targets:
		resolve_hit(target, tick_damage, tick_healing)

func resolve_hit(target: BaseCharacter, enemy_damage: int, ally_healing: int) -> void:
	if target.is_in_group("enemies") and enemy_damage > 0.0:
		target.health_changed.emit(enemy_damage, true)
	elif (target.is_in_group("players") or target.is_in_group("vip")) and ally_healing > 0.0:
		target.health_changed.emit(ally_healing, false)
		(target.get_node("StatusEffectCreator") as StatusEffectCreator)\
			.apply_effect(StatusEffect.STATUS_EFFECT_TYPE.REGEN, 8)


func create_vfx(path_to_vfx: String) -> VFX:
	var vfx_scene: PackedScene = load(path_to_vfx)
	var new_vfx: Node2D = vfx_scene.instantiate()
	
	return new_vfx


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func _on_tick_timer_timeout() -> void:
	on_tick()
