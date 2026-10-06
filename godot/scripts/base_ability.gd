class_name BaseAbility extends Resource

@export var ability_name: String = "base_ability"
@export var ability_type: String = "default"
@export var lifetime: float = 0.0
@export var dash_time: float = 0.0
@export var tick_interval: float = 0.0
@export var damage: int = 0
@export var dash_damage: int = 0
@export var dash_healing: int = 0
@export var landing_damage: int = 0
@export var landing_healing: int = 0
@export var distance: int = 0
@export var projectile_speed: int = 0
@export var healing: int = 0
@export var tick_damage: int = 0
@export var tick_healing: int = 0
@export var is_top_level: bool = false
@export var follows_reticle: bool = false
@export var path_to_vfx: String
