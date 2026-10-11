class_name CharacterSprite
extends AnimatedSprite2D


## if provided, the sprite can face left or right toward the aimable hurtbox
## instead of the movement direction.
## has no effect upon the hurtbox itself.
@export var aimable_hurtbox_to_face: AimableHurtbox

## to prevent spamming of idle vs. walk animations,
## parent character must be still for this long before the idle animation will play
@export var idle_delay_seconds: float = 0

## how long the character has been still, 
## used with [code]idle_delay_seconds[/code]
var _accum_idle_delay: float = 0

## [code]CharacterSprite[/code] can hook into a parent 
## [code]BaseCharacter[/code]'s health changes to "insert" the 
## [code]hurt[/code] animation
@onready var parent := self.get_parent() as BaseCharacter


func _ready() -> void:
	if parent and parent is BaseCharacter:
		parent.health_changed.connect(_on_parent_health_changed)


func _process(delta: float) -> void:
	if _do_not_interrupt():
		return
	
	# walk if moving, idle if not moving
	# even though this is visual, 
	# its tie to movement means it should be in physics process
	var in_motion := parent.velocity != Vector2.ZERO
	if not in_motion and not _am_i_doing("idle"):
		_accum_idle_delay += delta
		if _accum_idle_delay >= idle_delay_seconds:
			_accum_idle_delay = 0
			play("idle")
	elif in_motion and not _am_i_doing("walk"):
		_accum_idle_delay = 0
		play("walk")
	
	# face the proper direction
	_check_aim_dir()


func _on_parent_health_changed(_amount: float, negative: bool) -> void:
	if negative and self.sprite_frames.has_animation("hurt"):
		play("hurt")


func _check_aim_dir() -> void:
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


func _am_i_doing(anim_name: String) -> bool:
	return self.is_playing() and self.animation == anim_name


func _do_not_interrupt() -> bool:
	# avoid interrupting certain actions
	return _am_i_doing("hurt") or _am_i_doing("attack")
