class_name DebuffAwarder extends Node2D

@onready var vip : BaseVIP = self.get_parent()

#debuffs are currently stored as lambda functions
var debuffs : Dictionary[String, Callable] = {
	"chance_to_ignore_follow_commands" : (func() -> void:
		vip.follow_chance = 70.0
		),
	
	"slow_down_while_not_following" : (func() -> void:
		vip.speed = 3500.0
		vip.started_following.connect(func() -> void: 
			vip.speed = 5000.0
			)
		vip.stopped_following.connect(func() -> void:
			vip.speed = 3500.0
			)
		),
	
	"smaller_follow_command_radius" : (func() -> void:
		vip.follow_command_range = 275.0),
	
	"periodic_distraction" : (func() -> void:
		var distraction_trigger_timer : Timer = $DistractionTriggerTimer
		distraction_trigger_timer.start()
		),
}

#list of names of all of the debuffs
#currently, applying a debuff will remove it from this table
var inactive_debuffs : Array [String] = [
	"chance_to_ignore_follow_commands",
	"slow_down_while_not_following",
	"smaller_follow_command_radius",
	"periodic_distraction"
]


func apply_random_debuff() -> void:
	#check if there are remaining debuffs available
	var remaining_debuff_count : int = inactive_debuffs.size()
	if remaining_debuff_count > 0:
		#get random debuff and call its associated function
		var random_debuff_num : int = randi_range(0,(remaining_debuff_count - 1))
		var random_debuff_name : String = inactive_debuffs.get(random_debuff_num)
		debuffs[random_debuff_name].call()
		
		print("applied debuff: " + random_debuff_name)
		
		#remove debuff from table to prevent it from being applied twice
		inactive_debuffs.erase(random_debuff_name)


func _on_distraction_duration_timer_timeout() -> void:
	#distraction is over!
	print("the vip is no longer distracted!")
	vip.can_follow = true
	if inactive_debuffs.find("slow_down_while_not_following") == -1:
		vip.speed = 3500.0
	else:
		vip.speed = 5000.0


func _on_distraction_trigger_timer_timeout() -> void:
	#vip is distracted! vip has picked a spot and refuses to move
	print("the vip is distracted and refuses to move!")
	vip.can_follow = false
	vip.speed = 0.0
	var distraction_duration_timer : Timer = $DistractionDurationTimer
	distraction_duration_timer.start()
