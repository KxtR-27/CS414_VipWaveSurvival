extends Node2D

@onready var wave_timer: Timer = $WaveTimer
@onready var enemy_timer: Timer = $EnemySpawnTimer
@onready var wave_bar: TextureProgressBar = $CanvasLayer/WaveTimerBar

@export var enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_timer.start()
	
	wave_bar.max_value = wave_timer.wait_time
	wave_bar.value = wave_bar.max_value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	wave_bar.value = wave_timer.time_left
	pass


func _on_enemy_timer_timeout() -> void:
	var enemy: BaseEnemy = enemy_scene.instantiate()

	# Choose a random location on Path2D.
	var enemy_spawn_location: PathFollow2D = $EnemySpawnPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	enemy.position = enemy_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(enemy)
	
	enemy_timer.start()
	pass # Replace with function body.


func _on_wave_timer_timeout() -> void:
	enemy_timer.paused = true
	wave_timer.paused = true
	pass # Replace with function body.
