extends Node

@onready var wave_timer: Timer = get_parent().get_node("WaveTimer")
@onready var wave_bar: TextureProgressBar = $CanvasLayer/WaveTimerBar

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
