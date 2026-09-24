class_name VFX extends Node2D

@onready var anim_player : AnimationPlayer = $AnimPlayer

func play() -> void:
	anim_player.play("ability_vfx")
