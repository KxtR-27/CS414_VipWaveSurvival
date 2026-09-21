extends Debuff

@export var distraction_duration_timer: Timer
@export var distraction_trigger_timer: Timer


func on_activation() -> void:
	distraction_trigger_timer.start()


func on_tick() -> void:
	vip.speed = 0
	vip.can_follow = false
	distraction_duration_timer.start()
	print("the vip is distracted!")


func _on_distraction_trigger_timer_timeout() -> void:
	on_tick()


func _on_distraction_duration_timer_timeout() -> void:
	vip.speed = vip.max_speed
	print("the vip is no longer distracted!")
	vip.can_follow = true
	
