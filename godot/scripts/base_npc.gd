@abstract
class_name BaseNPC
extends BaseCharacter

@export_enum("Follow", "Flee") var target_preference := "Follow"

@export_group("Following")
@export var target_to_follow: BaseCharacter
@export var closest_follow_distance: float = 80

@export_group("Fleeing")
@export var target_to_flee_from: BaseCharacter
@export var farthest_flee_distance: float = 300


func _physics_process(delta: float) -> void:
	# don't move without a target.
	# (if false, then there is at least one target)
	if not target_to_follow and not target_to_flee_from:
		self.velocity = Vector2.ZERO
		return
	
	# starts out falsy, either condition will make truthy
	var next_move := ""
	if is_following():
		next_move = "follow"
	elif is_fleeing():
		next_move = "flee"
	
	if next_move:
		var direction: Vector2
		
		if (next_move == "follow"):
			direction = self.global_position.direction_to(target_to_follow.global_position)
		else: # (next_move == "flee"):
			direction = target_to_flee_from.global_position.direction_to(self.global_position)
	
		self.velocity = direction * speed * delta
		move_and_slide()
	else:
		self.velocity = Vector2.ZERO


func is_following() -> bool:
	# if can't follow or if prefers to flee
	var should_follow := target_to_follow and (not target_to_flee_from or target_preference == "Follow")
	if not should_follow: 
		return false
	
	var distance := self.global_position.distance_to(target_to_follow.global_position)
	return distance > closest_follow_distance


func is_fleeing() -> bool:
	var should_flee := target_to_flee_from and (not target_to_follow or target_preference == "Flee")
	if not should_flee: 
		return false
	
	var distance := self.global_position.distance_to(target_to_flee_from.global_position)
	return distance < farthest_flee_distance
