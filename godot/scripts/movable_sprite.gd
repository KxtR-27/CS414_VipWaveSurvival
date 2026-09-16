extends AnimatedSprite2D


@onready var parent := self.get_parent() as BaseCharacter


func _ready() -> void:
	if parent and parent is BaseCharacter:
		parent.health_changed.connect(_on_parent_health_changed)


# using process because I'm not affecting physics, only visuals
func _process(_delta: float) -> void:
	var hurting := self.animation == "hurt" and self.is_playing()
	var attacking := self.animation == "attack" and self.is_playing()
	
	#prevents attacking animation from being interrupted
	if attacking or hurting: 
		return
	
	var moving := parent.velocity != Vector2.ZERO
	
	var walking := self.animation == "walk" and self.is_playing()
	var idling := self.animation == "idle" and self.is_playing()
	
	if not moving and not idling:
		play("idle")
	elif moving and not walking:
		play("walk")
	
	if parent.velocity.x < 0 and not flip_h:
		flip_h = true
	elif parent.velocity.x > 0 and flip_h:
		flip_h = false


func _on_attack_hurtbox_body_entered(_body: Node2D) -> void:
	play("attack")
	pass # Replace with function body.


func _on_parent_health_changed(_amount: float, negative: bool) -> void:
	if negative and self.sprite_frames.has_animation("hurt"):
		play("hurt")
