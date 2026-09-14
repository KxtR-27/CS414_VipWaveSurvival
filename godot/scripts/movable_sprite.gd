extends AnimatedSprite2D


@onready var parent := self.get_parent() as CharacterBody2D


# using process because I'm not affecting physics, only visuals
func _process(_delta: float) -> void:
	var moving := parent.velocity != Vector2.ZERO
	
	var walking := self.animation == "walk" and self.is_playing()
	var idling := self.animation == "idle" and self.is_playing()
	var attacking := self.animation == "attack" and self.is_playing()
	
	#prevents attacking animation from being interrupted
	if attacking: 
		return
	
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
