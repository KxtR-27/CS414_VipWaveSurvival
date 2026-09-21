extends Debuff

func on_activation() -> void:
	vip.started_following.connect(func() -> void: 
		vip.max_speed = 5000.0
		vip.speed = vip.max_speed
		)
		
	vip.stopped_following.connect(func() -> void: 
		vip.max_speed = 3500.0
		vip.speed = vip.max_speed
		)
