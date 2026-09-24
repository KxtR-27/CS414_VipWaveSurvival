class_name AuraSpell extends BaseSpell

@export var hitbox: Area2D

@export var tick_timer: Timer
@export var lifetime_timer: Timer

@export var vfx: VFX

var current_overlapping_targets: Array = []
var spell_caster: BasePlayer
var damage: int
var healing: int

func run(ability: BaseAbility, caster: BaseCharacter) -> void:
	#remember who cast this spell
	spell_caster = caster
	
	#set damage and healing numbers
	damage = ability.damage
	healing = ability.healing
	
	#add caster to observed targets
	current_overlapping_targets.append(caster)
	
	#turn hitbox on and start spell
	hitbox.monitoring = true
	tick_timer.start()
	lifetime_timer.start()
	
	if not ability.path_to_vfx.is_empty():
		var new_vfx : VFX = create_vfx(ability.path_to_vfx)
		if new_vfx:
			add_child(new_vfx)
			new_vfx.play()


func on_tick() -> void:
	for target: BaseCharacter in current_overlapping_targets:
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
	queue_free()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is BaseNPC:
		current_overlapping_targets.erase(body)


func create_vfx(path_to_vfx: String) -> VFX:
	var vfx_scene : PackedScene = load(path_to_vfx)
	var new_vfx : Node2D = vfx_scene.instantiate()
	
	return new_vfx
