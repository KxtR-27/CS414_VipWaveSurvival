class_name CharacterSprite
extends AnimatedSprite2D


## if provided, the sprite can face left or right toward the aimable hurtbox
## instead of the movement direction.
## has no effect upon the hurtbox itself.
@export var aimable_hurtbox_to_face: AimableHurtbox

@onready var parent := self.get_parent() as BaseCharacter


func _ready() -> void:
	if parent and parent is BaseCharacter:
		parent.health_changed.connect(_on_parent_health_changed)


# using process because I'm not affecting physics, only visuals
func _process(_delta: float) -> void:
	var hurting := self.animation == "hurt" and self.is_playing()
	var attacking := self.animation == "attack" and self.is_playing()
	# prevent interruption of hurting or attacking animations
	if attacking or hurting:
		return
	
	var in_motion := parent.velocity != Vector2.ZERO
	
	var walking := self.animation == "walk" and self.is_playing()
	var idling := self.animation == "idle" and self.is_playing()
	
	if not in_motion and not idling:
		play("idle")
	elif in_motion and not walking:
		play("walk")
	
	_check_facing()


func _on_parent_health_changed(_amount: float, negative: bool) -> void:
	if negative and self.sprite_frames.has_animation("hurt"):
		play("hurt")


func _check_facing() -> void:
	# check by movement velocity if no aimable hurtbox is provided
	var checking_movement := aimable_hurtbox_to_face == null
	var aiming_left: bool
	var aiming_right: bool
	
	if checking_movement:
		aiming_left = parent.velocity.x < 0
		aiming_right = parent.velocity.x > 0
	else: # aimable_hurtbox_to_face == true
		var hurtbox_rot_vector := Vector2.from_angle(aimable_hurtbox_to_face.global_rotation)
		aiming_left = hurtbox_rot_vector.x < 0
		aiming_right = hurtbox_rot_vector.x > 0
		
	if aiming_left and not flip_h:
		flip_h = true
	elif aiming_right and flip_h:
		flip_h = false


func _animation_exists(anim_name: String) -> bool:
	return self.sprite_frames.has_animation(anim_name)
