class_name CharacterSelectScreen extends Node2D

@onready var main_scene :=  preload("res://main.tscn")
@onready var player_scene : PackedScene = preload("res://components/base_player/base_player.tscn")
@onready var container : HBoxContainer = $Control/HBoxContainer
@onready var character_select_component : PackedScene = preload("res://components/character_select_component/character_select_component.tscn")
@onready var ready_players : Array

@export var join_label : Label
@export var begin_button : Button

var active_players : Array[int] = []
var player_array : Array[BasePlayer] = []


func _ready() -> void:
	begin_button.disabled = true
	PlayerTracker.player_connected.connect(_on_player_connected)


func _process(_delta: float) -> void:
	if active_players.size() >= 1 and active_players.size() == player_array.size():
		begin_button.disabled = false


func add_select_component(device_id: int) -> void:
	var new_char_select_component : CharacterSelectComponent = character_select_component.instantiate()
	new_char_select_component.character_selected.connect(_on_character_selected)
	new_char_select_component.device_id = device_id as DeviceIdGlobals.device_id

	container.add_child(new_char_select_component)
	active_players.append(device_id)


func _on_character_selected(sprite_frames_path: String, device_id: DeviceIdGlobals.device_id) -> void:
	var new_player : BasePlayer = player_scene.instantiate()
	
	new_player.sprite_frames = load(sprite_frames_path)
	new_player.player_index = device_id
	new_player.position = container.position + Vector2(device_id + 10, 0)
	player_array.append(new_player)


func _on_player_connected(device_id : DeviceIdGlobals.device_id) -> void:
	join_label.hide()
	add_select_component(device_id)


func _on_button_pressed() -> void:
	get_tree().root.add_child(main_scene.instantiate())
	for player_number in player_array.size():
		player_array[player_number].name = "BasePlayer%d" % player_number
		get_tree().root.get_node("Main").add_child(player_array[player_number])
	get_tree().root.get_node("CharacterSelectScreen").queue_free()
