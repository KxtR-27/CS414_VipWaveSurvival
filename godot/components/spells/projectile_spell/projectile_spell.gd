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
	var projectile_ability := ability as ProjectileAbility
	
	#remember who cast this spell
	spell_caster = caster
	
	#set ability values
	distance = projectile_ability.distance
	projectile_damage = projectile_ability.damage
	projectile_healing = projectile_ability.healing
	
	projectile_travel_time = projectile_ability.projectile_speed
	
	#get reticle direction and where to shoot toward
	var reticle: CollisionShape2D = caster.hurtbox.get_node("Shape") as CollisionShape2D
	
	var direction: Vector2 = (reticle.global_position - caster.global_position).normalized()
	
	#more than one projectile? (i.e. multishot)
	var projectile_count: int = projectile_ability.projectile_count
	if projectile_count > 1:
		var total_spread: float = deg_to_rad(60) #creates 60 degree cone
		var initial_spread: float = deg_to_rad(-30) #first projectile will start 30 degrees away from center
		var turn_radius: float = total_spread / (projectile_count - 1)
		
		#start 30 degrees to the left, then start sweeping right
		for projectile_index in range(projectile_count):
			var distance_to_turn: float = turn_radius * projectile_index
			var current_projectile_spread: float = initial_spread + distance_to_turn
			
			var projectile_direction: Vector2 = direction.rotated(current_projectile_spread)
			var new_projectile: Area2D = spawn_projectile(projectile_direction)
			
			#apply vfx
			if not ability.path_to_vfx.is_empty():
				var new_vfx: VFX = create_vfx(ability.path_to_vfx)
				if new_vfx:
					vfx = new_vfx
					new_projectile.add_child(vfx)
					vfx.play()
	else:
		var new_projectile: Area2D = spawn_projectile(direction)
		
		if not ability.path_to_vfx.is_empty():
			var new_vfx: VFX = create_vfx(ability.path_to_vfx)
			if new_vfx:
				vfx = new_vfx
				new_projectile.add_child(vfx)
				vfx.play()
	
	


func spawn_projectile(direction: Vector2) -> Area2D:
	var new_projectile: Area2D = projectile.duplicate()
	
	projectile.get_parent().add_child(new_projectile)
	new_projectile.global_position = spell_caster.global_position
	
	var landing_target: Vector2 = spell_caster.global_position + (direction * distance)
	
	#tween projectile's position to landing_target
	var tween: Tween = new_projectile.create_tween()
	tween.tween_property(new_projectile, "global_position", landing_target, projectile_travel_time)
	tween.finished.connect(
		func() -> void:
			new_projectile.queue_free()
	)
	
	#start monitoring
	new_projectile.monitoring = true
	tween.play()
	
	return new_projectile


func resolve_hit(target: BaseCharacter, enemy_damage: int, ally_healing: int) -> void:
	if target.is_in_group("enemies") and enemy_damage > 0.0:
		target.health_changed.emit(enemy_damage, true)
	elif (target.is_in_group("players") or target.is_in_group("vip")) and ally_healing > 0.0:
		target.health_changed.emit(ally_healing, false)


func on_projectile_hit(unit: BaseCharacter) -> void:
	resolve_hit(unit, projectile_damage, projectile_healing)


func create_vfx(path_to_vfx: String) -> VFX:
	var vfx_scene: PackedScene = load(path_to_vfx)
	var new_vfx: Node2D = vfx_scene.instantiate()
	
	return new_vfx


func _on_projectile_body_entered(body: Node2D) -> void:
		if body is BaseCharacter and (projectile_hits.find(body) == -1):
			projectile_hits.append(body)
			on_projectile_hit(body as BaseCharacter)
