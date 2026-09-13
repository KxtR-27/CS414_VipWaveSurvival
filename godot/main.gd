extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_timer: Timer
@export var wave_timer: Timer

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
