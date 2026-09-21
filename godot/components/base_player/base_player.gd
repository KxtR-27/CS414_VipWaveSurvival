class_name BasePlayer
extends BaseCharacter


# when you add a new ability action to the InputMap,
# put a new value in this enum
enum Ability {
	ABILITY_1,
	ABILITY_2,
	ATTACK,
}

signal ability_used(ability : BaseAbility)


@export var sprite_frames: SpriteFrames = preload("res://resources/swordsman_spriteframes.tres")
@export_group("Input")
@export var device_id: int
@export var use_kbm: bool


## preload abilities to use in current_selected_abilities
var heal_aura_ability : BaseAbility = preload("res://resources/abilities/healing_aura.tres")
var damage_aura_ability : BaseAbility = preload("res://resources/abilities/damaging_aura.tres")

## this maps ability enums to the desired ability to be run
var current_selected_abilities : Dictionary[Ability, BaseAbility] = {
	Ability.ABILITY_1 : damage_aura_ability,
	Ability.ABILITY_2 : heal_aura_ability,
}

## when you add a new ability action to the InputMap, put it here.
## key: StringName of the action
## value: corresponding Ability enum value
var ABILITY_ACTION_MAP: Dictionary[String, Ability] = {
		"ability_1" : Ability.ABILITY_1,
		"ability_2" : Ability.ABILITY_2,
		"attack" : Ability.ATTACK,
}
## when you add a new ability, put it here
var ability_on_cooldown: Dictionary[Ability, bool] = {
	Ability.ABILITY_1: false, 
	Ability.ABILITY_2: false,
	Ability.ATTACK: false,
}

## when you add a new ability, make a timer and link it here
@onready var ability_timers: Dictionary[Ability, Timer] = {
	Ability.ABILITY_1: $Cooldowns/Ability1Cooldown,
	Ability.ABILITY_2: $Cooldowns/Ability2Cooldown,
	Ability.ATTACK: $Cooldowns/AttackCooldown,
}

@onready var animated_sprite := $Sprite as AnimatedSprite2D


func _ready() -> void:
	animated_sprite.sprite_frames = sprite_frames


func _physics_process(delta: float) -> void:
	var move_dir := _get_movement_direction()
	self.velocity = move_dir * speed * delta
	self.move_and_slide()


func _input(event: InputEvent) -> void:
	if not _event_is_from_my_device(event):
		return
	
	var ability_action: String = _get_pressed_ability(event)
	if ability_action:
		_execute_ability(ability_action)
	
	elif event.is_action_pressed("start_follow"):
		print("I, device ", device_id, "/kbm:", use_kbm, " ask the VIPs to follow!")
		_command_vips_to_follow()
	
	elif event.is_action_pressed("stop_follow"):
		print("I, device ", device_id, "/kbm:", use_kbm, " ask the VIPs to go away!")
		_command_vips_to_stop_following()


## loops through all actions in ABILITY_ACTION_MAP.
## returns the pressed action String if it exists. 
## otherwise, returns an empty string "", which is [b]falsy[/b].
func _get_pressed_ability(event: InputEvent) -> String:
	for action: String in ABILITY_ACTION_MAP.keys():
		if event.is_action_pressed(action):
			return action
	
	return ""


## returns true if the input was an ability input; false otherwise
func _execute_ability(ability_action: String) -> void:
	# get the Ability enum value
	var ability: Ability = ABILITY_ACTION_MAP[ability_action]
	# return early if it's on cooldown
	if ability_on_cooldown[ability]: return
	# otherwise, start the cooldown
	_trigger_cooldown(ability)
	
	match (ability):
		Ability.ABILITY_1:
			var current_ability : BaseAbility = current_selected_abilities[Ability.ABILITY_1]
			ability_used.emit(current_ability)
		Ability.ABILITY_2:
			var current_ability : BaseAbility = current_selected_abilities[Ability.ABILITY_2]
			ability_used.emit(current_ability)
		Ability.ATTACK:
			#play attack animation
			var sprite : AnimatedSprite2D = $Sprite
			sprite.play("attack")
			
			#use animationplayer to turn hitbox on and off
			var sword_animator : AnimationPlayer = $SwordHitboxAnimator
			sword_animator.play("attack")
		
	return


func _command_vips_to_follow() -> void:
	for vip in _get_vips():
		var dist_to_player := self.global_position.distance_to(vip.global_position)
		if dist_to_player < vip.follow_command_range:
			print(self.name, ": Follow me, ", vip.name, "!")
			vip.request_to_follow(self)


func _command_vips_to_stop_following() -> void:
	for vip in _get_vips():
		if vip.target_to_follow == self:
			print(self.name, ": You should be safe here, ", vip.name, ".")
			vip.request_to_stop_following(self)


func _get_vips() -> Array[BaseVIP]:
	var all_vip_nodes := get_tree().get_nodes_in_group("vip")
	var vips := all_vip_nodes.filter(
			func(vip: Node) -> bool: return vip is BaseVIP
	)
	return vips


## sets an ability's cooldown to true and starts its cooldown timer
func _trigger_cooldown(ability: Ability) -> void:
	ability_on_cooldown[ability] = true
	ability_timers[ability].start()


func _on_ability_1_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ABILITY_1] = false


func _on_ability_2_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ABILITY_2] = false


func _on_attack_cooldown_timeout() -> void:
	ability_on_cooldown[Ability.ATTACK] = false


func _on_attack_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var enemy := body as BaseNPC
		enemy.take_damage(25)
	pass # Replace with function body.


func _on_health_component_died() -> void:
	self.queue_free()
	pass # Replace with function body.


func _event_is_from_my_device(event: InputEvent) -> bool:
	var event_device := event.device
	
	if use_kbm:
		return DeviceManager.is_kbm(event_device)
	else:
		return event_device == self.device_id


func _get_movement_direction() -> Vector2:
	if use_kbm:
		return Input.get_vector("move_left", "move_right", "move_up", "move_down")
	else:
		return Vector2(
			Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y),
		)
