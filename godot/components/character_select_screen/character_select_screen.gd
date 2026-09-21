class_name CharacterSelectScreen extends Node2D

static var main_scene :=  preload("res://main.tscn")
static var player_scene := preload("res://components/base_player/base_player.tscn")
static var character_select_component := preload("res://components/character_select_component/character_select_component.tscn")

var active_players: Array[int] = []
var player_array: Array[BasePlayer] = []

var connected_player_array: Array[int] = []

@onready var container := $Control/HBoxContainer as HBoxContainer
@onready var join_label := $Control/ClickToJoinLabel as Label
@onready var begin_button := $Control/Button as Button


func _ready() -> void:
	begin_button.disabled = true


func _process(_delta: float) -> void:
	if active_players.size() >= 1 and active_players.size() == player_array.size():
		begin_button.disabled = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join") and event.device not in connected_player_array:
		add_player(event.device)
		_on_player_connected(event.device)


func add_select_component(device_id: int) -> void:
	var new_char_select_component: CharacterSelectComponent = character_select_component.instantiate()
	new_char_select_component.character_selected.connect(_on_character_selected)
	new_char_select_component.device_id = 16 if DeviceManager.is_kbm(device_id) else device_id

	container.add_child(new_char_select_component)
	active_players.append(device_id)


func _on_character_selected(sprite_frames_path: String, device_id: int) -> void:
	var new_player := player_scene.instantiate() as BasePlayer
	
	new_player.sprite_frames = load(sprite_frames_path)
	new_player.device_id = device_id
	new_player.use_kbm = DeviceManager.is_kbm(device_id)
	new_player.position = container.position + Vector2(device_id + 10, 0)
	player_array.append(new_player)


func _on_player_connected(device_id: int) -> void:
	join_label.hide()
	add_select_component(device_id)


func _on_button_pressed() -> void:
	get_tree().root.add_child(main_scene.instantiate())
	for player_number in player_array.size():
		player_array[player_number].name = "BasePlayer%d" % player_number
		get_tree().root.get_node("Main").add_child(player_array[player_number])
	get_tree().root.get_node("CharacterSelectScreen").queue_free()


func add_player(device_id: int) -> void:
	connected_player_array.append(device_id)
