class_name WaveSystem extends Node2D

signal wave_start

@onready var wave_timer: Timer = $WaveTimer
@onready var enemy_timer: Timer = $EnemySpawnTimer
@onready var wave_timer_bar: TextureProgressBar = $WaveTimerBar/TimerBar
@onready var wave_notification_layer: CanvasLayer = $WaveNotifications
@onready var wave_notification_label: Label = $WaveNotifications/Control/HBoxContainer/VBoxContainer/Label
@onready var initial_spawner_wait_time: float = enemy_timer.wait_time

@onready var wave_dict: Dictionary = {
	1: [["wave length", 1], ["enemy speed", 0.5], ["spawning speed multiplier", 1]],
	2: [["wave length", 1.25], ["enemy speed", 1], ["spawning speed multiplier", 1]],
	3: [["wave length", 1.5], ["enemy speed", 1], ["spawning speed multiplier", 2]],
	4: [["wave length", 1.75], ["enemy speed", 1.5], ["spawning speed multiplier", 2]], 
	5: [["wave length", 2], ["enemy speed", 1.5], ["spawning speed multiplier", 3]]
}
enum {
	WAVE_LENGTH = 0,
	ENEMY_SPEED = 1,
	SPAWN_MULT = 2
}

@export var wave_tracker: WaveTracker = preload("res://resources/wave_tracker.tres")

@export var enemy_scene: PackedScene = preload("res://components/base_enemy/base_enemy.tscn")
@export var enemy_speed: float = 0.5

var num_spawned: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_tracker.current_wave = 1
	
	wave_start.emit()
	
	wave_timer_bar.max_value = wave_timer.wait_time
	wave_timer_bar.value = wave_timer_bar.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !wave_timer.paused:
		wave_timer_bar.max_value = wave_timer.wait_time
		wave_timer_bar.value = wave_timer.time_left
		wave_timer_bar.tint_progress = "#ff0000"

# Creates new enemy after specified interval
func _on_enemy_timer_timeout() -> void:
	var enemy: BaseEnemy = enemy_scene.instantiate()

	# Choose a random location on Path2D.
	var enemy_spawn_location := $EnemySpawnPath/EnemySpawnLocation as PathFollow2D
	enemy_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	enemy.position = enemy_spawn_location.position
	enemy.speed *= enemy_speed

	# Spawn the mob by adding it to the Main scene.
	get_parent().add_child(enemy)
	
	enemy.name = "BaseEnemy%d" % ++num_spawned
	enemy_timer.start()


func _on_wave_timer_timeout() -> void:
	enemy_timer.paused = true
	wave_timer.paused = true
	
	wave_tracker.current_wave += 1
	print("wave ", wave_tracker.current_wave, " complete!")
	prepare_new_wave()
	
	#apply debuff to VIP on every wave past wave 1
	if wave_tracker.current_wave > 1:
		var debuff_awarder := self.get_parent().get_node("DebuffAwarder") as DebuffAwarder
		debuff_awarder.award_debuff()
		
	wave_start.emit()


func prepare_new_wave() -> void:
	# prevents index out of bounds crash
	var safe_wave_count: int = (wave_tracker.current_wave % wave_dict.size()) + 1
	print("using safe wave count: ", safe_wave_count)
	
	if wave_tracker.current_wave > safe_wave_count:
		GlobalEvents.win_game()
	
	wave_timer.wait_time *= wave_dict[safe_wave_count][WAVE_LENGTH][1]
	enemy_speed = wave_dict[safe_wave_count][ENEMY_SPEED][1]
	
	reset_spawner_timer()
	enemy_timer.wait_time /= wave_dict[safe_wave_count][SPAWN_MULT][1]
	

func reset_spawner_timer() -> void:
	enemy_timer.wait_time = initial_spawner_wait_time


func _on_wave_start() -> void:
	wave_timer.paused = false
	enemy_timer.paused = false
	enemy_timer.start()
	wave_timer.start()
	
	wave_notification_layer.visible = true
	wave_notification_label.text = "Wave %d Start" % wave_tracker.current_wave
	
	await get_tree().create_timer(1.5).timeout
	
	wave_notification_layer.visible = false
