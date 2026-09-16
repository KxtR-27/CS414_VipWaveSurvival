@tool
class_name TargetScanner
extends Area2D


signal target_scanned(character: BaseCharacter, flee: bool)

## Due to a limitation of the engine, this is as close to a live update or bound 
## state without the value resetting when you hit play.
##
## This update also happens on _ready(), by the way.
@export_range(0, 40, 0.001, "or_greater") var radius_tool: float = 10

@export_tool_button("Update Radius", "CircleShape2D") \
	var radius_button := func() -> void: scan_shape.radius = radius_tool

@export_group("Scanning")
@export_flags("enemies:1","enemy_targets:2","players:4","vip:8") var scan_groups := 0b1111
@export_enum("Follow", "Flee") var scan_purpose := "Follow"
@export var scan_switching: bool = true

@export_group("Debug")
@export var should_log: bool = false


@onready var scan_shape := ($Shape as CollisionShape2D).shape as CircleShape2D


func _ready() -> void:
	scan_shape.radius = radius_tool
	assert(get_parent() is BaseNPC, "The parent of a TargetScanner must be a BaseNPC.")


func _get_parent_current_target() -> Variant: # Variant as in BaseCharacter or null
	var parent: BaseNPC = get_parent()
	if not parent: return null
	
	if scan_purpose == "Follow":
		return parent.target_to_follow
	else: # scan_purpose == "Flee"
		return parent.target_to_flee_from


func _character_in_scan_groups(character: BaseCharacter) -> bool:
	# bitwise AND. `scan_groups & 1` means that "enemies" is checked
	return (
			(scan_groups & 1 and character.is_in_group("enemies"))
			or (scan_groups & 2 and character.is_in_group("enemy_targets"))
			or (scan_groups & 4 and character.is_in_group("players"))
			or (scan_groups & 8 and character.is_in_group("vip"))
	)


## check if body is a satisfactory target
func _on_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint() or body == get_parent() or body == self:
		return # silently
	
	if not body is BaseCharacter:
		if should_log: 
			print(get_parent().name, ": scanned body ", body.name, " is not a BaseCharacter")
		return
	
	var character := body as BaseCharacter
	
	# if already targeting the body, return early
	if character == _get_parent_current_target(): 
		if should_log: 
			print(get_parent().name, ": already targeting the scanned body ", body.name)
		return
	
	# if not switching targets, return early
	elif not scan_switching: 
		if should_log: 
			print(get_parent().name, ": scanned a new target (", body.name ,"), but scan-switching is disabled")
		return
	
	# if the body isn't a valid target, return early
	elif not _character_in_scan_groups(character):
		if should_log:
			print(get_parent().name, ": scanned body ", body.name, " is not in current scanning groups")
		return
	
	# otherwise, we are scanning, the body is new to us, and it's a valid target
	else:
		if should_log:
			print(get_parent().name, ": scanned scanned valid target: ", body.name) 
		target_scanned.emit(character, scan_purpose == "Flee")
