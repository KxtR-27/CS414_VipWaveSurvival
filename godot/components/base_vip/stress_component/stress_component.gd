class_name StressComponent
extends ProgressBar


signal stress_limit_reached


## when the VIP travels a distance below this threshold, their stress increases.
## this does not apply when the VIP is following a player.
## this also does not apply when the VIP is not fleeing.
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var distance_traveled_threshold: float = 50.0
@export_range(0.0, 100.0, 1.0, "suffix:%") var stress_gain: float = 20.0
@export var debug_print: bool = false

@onready var panic_sound := $PanicSound as AudioStreamPlayer


## when stress reaches 100%, [signal stress_limit_reached] emits.
## stress is between 0.0 and 100.0 (inclusive)
var stress: float = 0.0:
	set(new_stress):
		if new_stress >= 100.0:
			stress = 0
			stress_limit_reached.emit()
			if panic_sound:
				panic_sound.play()
			parent_vip.panic()
		else:
			stress = new_stress
		self.value = stress

## the last position of the BaseVIP parent.
## updated every time the stress timer times out.
var last_checked_position: Vector2

# get_parent() = BarsContainer; BarsContainer.get_parent() = base_vip
@onready var parent_vip := self.get_parent().get_parent() as BaseVIP
@onready var timer := $StressTimer as Timer


func _ready() -> void:
	if not parent_vip:
		return
	
	last_checked_position = parent_vip.global_position


func _on_stress_timer_timeout() -> void:
	var current_position := parent_vip.global_position
	var current_distance := last_checked_position.distance_to(current_position) 
	
	if (
			parent_vip.is_fleeing()
			and not parent_vip.panicking
			and current_distance <= distance_traveled_threshold
	):
		stress += stress_gain
		if debug_print:
			print("stress increased to %.0f by distance-based gain %.0f" % [stress, stress_gain])
	elif debug_print:
		print("distance-based check ran, but stress was not gained.")
	
	last_checked_position = current_position
