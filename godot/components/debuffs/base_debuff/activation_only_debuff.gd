@abstract
class_name ActivationOnlyDebuff
extends Debuff


@abstract
func on_activation() -> void


# literally, an activation-only debuff does not tick,
# so subclasses can pass on this
func on_tick() -> void:
	pass
