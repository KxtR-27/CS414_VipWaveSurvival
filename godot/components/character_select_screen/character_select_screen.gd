class_name CharacterSelectScreen extends Node2D

@onready var main_scene :=  preload("res://main.tscn")
@onready var player_scene : PackedScene = preload("res://components/base_player/base_player.tscn")
@onready var container : HBoxContainer = $Control/HBoxContainer
@onready var character_select_component : PackedScene = preload("res://components/character_select_component/character_select_component.tscn")
@onready var ready_players : Array

@export var join_label : Label
@export var begin_button : Button
@export var player_index : int = 0

var active_players : Array[int] = []
var player_array : Array[BasePlayer] = []

var input_map : Array = [
	"move_right{n}".format({"n":player_index}),
	"move_left{n}".format({"n":player_index}),
	"move_up{n}".format({"n":player_index}),
	"move_down{n}".format({"n":player_index}),
	"select{n}".format({"n":player_index}),
]

func _ready() -> void:
	begin_button.disabled = true


func add_player(device_id: int) -> void:
	var new_char_select_component : CharacterSelectComponent = character_select_component.instantiate()
	new_char_select_component.character_selected.connect(_on_character_selected)
	new_char_select_component.device_id = device_id as DeviceIdGlobals.device_id

	container.add_child(new_char_select_component)
	active_players.append(device_id)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join") and event.device not in active_players:
		join_label.hide()
		player_index = event.device
		add_player(event.device)
	pass
	

func _on_character_selected(sprite_frames_path: String) -> void:
	var new_player : BasePlayer = player_scene.instantiate()
	
	new_player.sprite_frames = load(sprite_frames_path)
	new_player.position = container.global_position
	new_player.player_index = player_index as DeviceIdGlobals.device_id
	
	player_array.append(new_player)
	
	begin_button.disabled = false


func _on_button_pressed() -> void:
	get_tree().root.add_child(main_scene.instantiate())
	for player_number in player_array.size():
		player_array[player_number].name = "BasePlayer%d" % player_number
		get_tree().root.get_node("Main").add_child(player_array[player_number])
	get_tree().root.get_node("CharacterSelectScreen").queue_free()
	pass # Replace with function body.
