extends Debuff

func on_activation() -> void:
	vip.follow_command_range -= 150.0
