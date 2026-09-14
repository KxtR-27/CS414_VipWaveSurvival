class_name WaveSystem extends Node2D

@onready var wave_timer: Timer = $WaveTimer
@onready var enemy_timer: Timer = $EnemySpawnTimer
@onready var downtime_timer: Timer = $DowntimeTimer
@onready var wave_bar: TextureProgressBar = $CanvasLayer/WaveTimerBar

@onready var wave_dict: Dictionary = {
	1 : [["wave length", 1], ["enemy speed", 0.5], ["enemy multiplier", 1]],
	2 : [["wave length", 1.25], ["enemy speed", 1], ["enemy multiplier", 1]],
	3 : [["wave length", 1.5], ["enemy speed", 1], ["enemy multiplier", 2]],
	4 : [["wave length", 1.75], ["enemy speed", 1.5], ["enemy multiplier", 2]], 
	5 : [["wave length", 2], ["enemy speed", 1.5], ["enemy multiplier", 3]]
}
enum {
	WAVE_LENGTH = 0,
	ENEMY_SPEED = 1,
	ENEMY_MULT = 2
}

@export var enemy_scene: PackedScene
@export var wave_tracker: WaveTracker
@export var enemy_speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_timer.start()
	wave_tracker.current_wave = 1
	
	wave_bar.max_value = wave_timer.wait_time
	wave_bar.value = wave_bar.max_value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !wave_timer.paused:
		wave_bar.max_value = wave_timer.wait_time
		wave_bar.value = wave_timer.time_left
		wave_bar.tint_progress = "#ff0000"
	else:
		wave_bar.max_value = downtime_timer.wait_time
		wave_bar.value = downtime_timer.wait_time - downtime_timer.time_left 
		wave_bar.tint_progress = "00ff00" 
	pass


# Creates new enemy after specified interval
func _on_enemy_timer_timeout() -> void:
	var enemy: BaseEnemy = enemy_scene.instantiate()

	# Choose a random location on Path2D.
	var enemy_spawn_location: PathFollow2D = $EnemySpawnPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	enemy.position = enemy_spawn_location.position
	enemy.speed *= enemy_speed

	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
	
	enemy_timer.start()
	pass # Replace with function body.


func _on_wave_timer_timeout() -> void:
	enemy_timer.paused = true
	wave_timer.paused = true
	
	wave_tracker.current_wave += 1
	prepare_new_wave()
	
	downtime_timer.paused = false
	downtime_timer.start()
	pass # Replace with function body.


func _on_downtime_timer_timeout() -> void:
	downtime_timer.paused = true
	wave_timer.paused = false
	enemy_timer.paused = false
	
	wave_timer.start()
	enemy_timer.start()
	pass # Replace with function body.


func prepare_new_wave() -> void:
	wave_timer.wait_time *= wave_dict[wave_tracker.current_wave][WAVE_LENGTH][1]
	enemy_speed = wave_dict[wave_tracker.current_wave][ENEMY_SPEED][1]
	enemy_timer.wait_time /= wave_dict[wave_tracker.current_wave][ENEMY_MULT][1]
