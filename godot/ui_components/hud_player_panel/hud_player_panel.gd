class_name HudPlayerPanel extends Panel

enum Ability {ABILITY_1, ABILITY_2}

var currently_tracking: bool = false

@onready var health_bar: ProgressBar = $HealthBar
@onready var player_icon: TextureRect = $PlayerIcon
@onready var player_indicator: Label = $PlayerIndicator
@onready var health_text: Label = $HealthBar/HealthTextLabel

@onready var ability_icons: Dictionary[Ability, Control] = {
	Ability.ABILITY_1: $Ability1Icon,
	Ability.ABILITY_2: $Ability2Icon,
}

@onready var ability_cooldown_timers: Dictionary[Ability, Timer] = {
	Ability.ABILITY_1: $Ability1Cooldown,
	Ability.ABILITY_2: $Ability2Cooldown,
}

var ability_names: Dictionary[Ability, String] = {
	Ability.ABILITY_1: "",
	Ability.ABILITY_2: "",
}

var last_ability_cooldowns: Dictionary[Ability, float] = {
	Ability.ABILITY_1: 0.0,
	Ability.ABILITY_2: 0.0,
}

var ability_on_cooldown: Dictionary[Ability, bool] = {
	Ability.ABILITY_1: false,
	Ability.ABILITY_2: false,
}


func _physics_process(_delta: float) -> void:
	if currently_tracking:
		for ability: Ability in ability_on_cooldown.keys():
			if ability_on_cooldown[ability]:
				var ability_icon: TextureRect = ability_icons[ability]
				var progress_bar: ProgressBar = ability_icon.get_node("CooldownProgress")
				var timer: Timer = ability_cooldown_timers[ability]
				
				progress_bar.value = (timer.time_left / last_ability_cooldowns[ability]) * 100


func connect_to_player(player: BasePlayer, hero_name: String, player_number: int, color: Color) -> void:
	currently_tracking = true
	visible = true
	
	#set ability names
	var first_ability: BaseAbility = player.current_selected_abilities[BasePlayer.Ability.ABILITY_1]
	var second_ability: BaseAbility = player.current_selected_abilities[BasePlayer.Ability.ABILITY_2]
	ability_names[Ability.ABILITY_1] = first_ability.ability_name
	ability_names[Ability.ABILITY_2] = second_ability.ability_name
	
	#connect cooldowns and health bar
	player.cooldown_started.connect(func(ability: BaseAbility) -> void:
		for index: int in ability_names.keys():
			if ability_names[index] == ability.ability_name:
				trigger_cooldown(index, 5.0)
				last_ability_cooldowns[index] = 5.0
				break
	)
	
	health_bar.value = player.character_stats.max_health
	health_bar.max_value = player.character_stats.max_health
	update_health_text(player.character_stats.max_health, player.character_stats.max_health)
	
	player.health_changed.connect(func(_amount: float, _negative: bool) -> void:
		health_bar.value = player.health_component.current_health
		health_bar.max_value = player.health_component.max_health
		update_health_text(player.health_component.current_health, player.health_component.max_health)
	)
	
	player.health_component.max_health_changed.connect(func(max_health: float, current_health: float) -> void:
		health_bar.max_value = max_health
		health_bar.value = current_health
		update_health_text(current_health, max_health)
	)
	
	player.health_component.health_refreshed.connect(func(new_max: float, current_value: float) -> void:
		health_bar.max_value = new_max
		health_bar.value = current_value
		update_health_text(current_value, new_max)
	)
	
	player.character_stats.stats_changed.connect(func(_damage: float, max_health: float, _speed: float) -> void:
		var current_proportion: float = health_bar.value / health_bar.max_value
		var new_value: float = max_health * current_proportion
		
		health_bar.value = new_value
		health_bar.max_value = max_health
		update_health_text(player.health_component.current_health, max_health)
	)
	
	#set player icon
	match hero_name:
		"swordsman": 
			(player_icon.get_node("swordsman") as TextureRect).visible = true
		"knight": 
			(player_icon.get_node("knight") as TextureRect).visible = true
		"wizard": 
			(player_icon.get_node("wizard") as TextureRect).visible = true
		"archer":
			(player_icon.get_node("archer") as TextureRect).visible = true
	
	#set color and text for indicator label
	($BackgroundPanel as Panel).modulate = color
	player_indicator.modulate = color
	player_indicator.text = "P" + str(player_number + 1)


func trigger_cooldown(index: int, cooldown: float) -> void:
	ability_cooldown_timers[index].start(cooldown)
	(ability_icons[index].get_node("CooldownProgress") as ProgressBar).visible = true
	ability_on_cooldown[index] = true


func update_health_text(current_health: float, max_health: float) -> void:
	health_text.text = "%.1f / %.1f" % [current_health, max_health]


func _on_ability_1_cooldown_timeout() -> void:
	(ability_icons[Ability.ABILITY_1].get_node("CooldownProgress") as ProgressBar).visible = false
	ability_on_cooldown[Ability.ABILITY_1] = false


func _on_ability_2_cooldown_timeout() -> void:
	(ability_icons[Ability.ABILITY_2].get_node("CooldownProgress") as ProgressBar).visible = false
	ability_on_cooldown[Ability.ABILITY_2] = false
