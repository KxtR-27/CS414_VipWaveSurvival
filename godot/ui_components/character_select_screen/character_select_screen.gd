class_name CharacterSelectScreen extends Node2D

signal player_joined(player_num: int)

static var main_scene :=  preload("res://main_game.tscn")
static var player_scene := preload("res://components/base_player/base_player.tscn")
static var character_select_component := preload("res://ui_components/character_select_component/character_select_component.tscn")

var player_array: Array[BasePlayer] = []

var connected_player_array: Array[int] = []

const INDICATOR_COLOR_MAP: Dictionary[int, Color] = {
	0: Color.RED,
	1: Color.BLUE,
	2: Color.GREEN,
	3: Color.YELLOW,
	4: Color.AQUA,
	5: Color.HOT_PINK,
	6: Color.PURPLE,
	7: Color.ORANGE,
}
var characters: Dictionary = {
	0: "swordsman",
	1: "wizard",
	2: "knight"
}

const RANGED_HERO_ABILITIES: Dictionary[String, BaseAbility] = {
	"wizard" : preload("res://resources/abilities/wizard_ranged_attack.tres")
}

const HERO_ABILITIES: Dictionary[String, Dictionary]  = {
	"swordsman" : {
		"ABILITY_1" : preload("res://resources/abilities/swordsman_ability_one.tres"),
		"ABILITY_2" : preload("res://resources/abilities/swordsman_ability_two.tres"),
	},
	"wizard" : {
		"ABILITY_1" : preload("res://resources/abilities/wizard_ability_one.tres"),
		"ABILITY_2" : preload("res://resources/abilities/wizard_ability_two.tres"),
	},
	"knight" : {
		"ABILITY_1" : preload("res://resources/abilities/knight_ability_one.tres"),
		"ABILITY_2" : preload("res://resources/abilities/knight_ability_two.tres"),
	},
}

const HERO_STATS: Dictionary[String, Dictionary] = {
	"swordsman" : {
		"damage" : 25.0,
		"max_health" : 100.0,
		"speed" : 5000.0,
	}, 
	"wizard" : {
		"damage" : 20.0,
		"max_health" : 75.0,
		"speed" : 4000.0,
	},
	"knight" : {
		"damage" : 15.0,
		"max_health" : 125.0,
		"speed" : 3000.0,
	}
}

@onready var container := $CanvasLayer/Control/HBoxContainer as HBoxContainer
@onready var join_label := $CanvasLayer/Control/ClickToJoinLabel as Label
@onready var begin_button := $CanvasLayer/Control/Button as Button
@onready var begin_button_sound := $CanvasLayer/Control/Button/ButtonSound as AudioStreamPlayer
@onready var join_sound := $JoinSound as AudioStreamPlayer
@onready var ready_sound := $ReadySound as AudioStreamPlayer


func _ready() -> void:
	begin_button.disabled = true


func _process(_delta: float) -> void:
	if connected_player_array.size() >= 1 and connected_player_array.size() == player_array.size():
		begin_button.disabled = false
	elif connected_player_array.size() > player_array.size():
		begin_button.disabled = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join") and event.device not in connected_player_array and connected_player_array.size() <= 4:
		connected_player_array.append(event.device)
		_on_player_connected(event.device)
		join_sound.play()


func enable_select_component(device_id: int) -> void:
	var new_char_select_component := container.get_child(connected_player_array.size() - 1) as CharacterSelectComponent
	new_char_select_component.device_id = 16 if DeviceManager.is_kbm(device_id) else device_id


func _on_character_selected(selected_character: String, sprite_frames_path: String, device_id: int) -> void:
	ready_sound.play()
	var new_player := player_scene.instantiate() as BasePlayer
	
	new_player.sprite_frames = load(sprite_frames_path)
	new_player.device_id = device_id
	new_player.use_kbm = DeviceManager.is_kbm(device_id)
	new_player.position = container.position + Vector2(device_id + 10, 0)
	new_player.hero_name = selected_character
	
	new_player.override_abilities(HERO_ABILITIES[selected_character])
	if RANGED_HERO_ABILITIES.keys().find(selected_character) != -1:
		new_player.uses_ranged_attacks = true
		new_player.ranged_attack_ability = RANGED_HERO_ABILITIES[selected_character]
	
	player_array.append(new_player)


func _on_player_connected(device_id: int) -> void:
	enable_select_component(device_id)
	player_joined.emit(connected_player_array.size())


func _on_button_pressed() -> void:
	var main_scene_node: Node = main_scene.instantiate()
	get_tree().root.add_child(main_scene_node)
	for player_number: int in range(player_array.size()):
		var player_hero: BasePlayer = player_array[player_number]
		
		player_hero.name = "BasePlayer%d" % player_number
		get_tree().root.get_node("Main").add_child(player_hero)
		GlobalPlayerManager.players.get_or_add(player_hero.hero_name, player_number)
		
		#set player indicator and hud up
		set_up_indicator(player_hero, player_number)
		
		var hud: Control = main_scene_node.get_node("HUD")
		var panels: Control = hud.get_node("PlayerPanels")
		for panel: HudPlayerPanel in panels.get_children():
			if panel.name == str(player_number + 1):
				panel.connect_to_player(
					player_hero, 
					player_hero.hero_name, 
					player_number, 
					INDICATOR_COLOR_MAP[player_number]
				)
				break
		
		#assign stats for selected hero
		var selected_stats: Dictionary = HERO_STATS[player_hero.hero_name]
		player_hero.character_stats.damage = selected_stats["damage"]
		player_hero.character_stats.max_health = selected_stats["max_health"]
		player_hero.character_stats.speed = selected_stats["speed"]
		player_hero.character_stats.apply_stats()
		player_hero.get_node("HealthComponent").refresh()
	
	await begin_button_sound.finished
	get_tree().root.get_node("CharacterSelectScreen").queue_free()


func set_up_indicator(base_player: BasePlayer, player_index: int) -> void:
	var indicator: Control = base_player.get_node("PlayerIndicator")
	var indicator_vbox: VBoxContainer = indicator.get_node("VBoxContainer")
	var indicator_label: Label = indicator_vbox.get_node("Label")
	var indicator_texture: TextureRect = indicator_vbox.get_node("CenterContainer").get_node("TextureRect")
	
	indicator_label.modulate = INDICATOR_COLOR_MAP[player_index]
	indicator_texture.modulate = INDICATOR_COLOR_MAP[player_index]
	
	indicator_label.text = "P" + str(player_index + 1)
