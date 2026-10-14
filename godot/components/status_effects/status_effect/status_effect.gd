class_name StatusEffect extends Node2D

enum STATUS_EFFECT_TYPE {
	BURN,
	REGEN
}

@export var status_name: String
@export var effect_type: STATUS_EFFECT_TYPE
@export var num_stacks: int
@export var max_stacks: int # set to 0 if you do not want a limit
@export var max_lifetime: float # set to 0 if you do not want a limit
@export var affected_unit: BaseCharacter

@onready var tick_timer: Timer = $TickTimer
@onready var lifetime_timer: Timer = $TickTimer

signal finished


func apply(_starting_stacks: int) -> void:
	pass


func add_stacks(amount: int) -> void:
	var new_stacks: int = num_stacks + amount
	var old_stacks: int = num_stacks
	
	if max_stacks: # will evaluate to false if max_stacks == 0
		new_stacks = min(new_stacks, max_stacks)
	
	num_stacks = new_stacks
	
	if old_stacks != new_stacks:
		on_add_stack()


func remove_stacks(amount: int) -> void:
	num_stacks -= amount
	
	if num_stacks <= 0:
		on_cleanse()
		finished.emit()
	else:
		on_remove_stack()


func on_create() -> void:
	pass


func on_tick() -> void:
	pass


func on_add_stack() -> void:
	pass


func on_remove_stack() -> void:
	pass


func on_cleanse() -> void:
	pass


func _on_tick_timer_timeout() -> void:
	on_tick()


func _on_lifetime_timer_timeout() -> void:
	on_cleanse()
	finished.emit()
