class_name Debuff extends Node2D

@export var debuff_name := "Debuff"
@export var debuff_description := "This is a debuff."
var vip: BaseVIP

@warning_ignore("unused_signal")
# kat is ignoring this warning because it already works and kat didn't make it.
signal debuff_activated

func on_activation() -> void:
	pass


func on_tick() -> void: 
	pass


func _on_debuff_activated() -> void:
	on_activation()
