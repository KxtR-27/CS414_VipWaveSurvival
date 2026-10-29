class_name HudPlayerPanel extends Panel

enum Ability {ABILITY_1, ABILITY_2}

var currently_tracking: bool = false

@onready var health_bar: ProgressBar = $HealthBar
@onready var player_icon: TextureRect = $PlayerIcon
@onready var player_indicator: Label = $PlayerIndicator

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
	
	player.health_changed.connect(func(_amount: float, _negative: bool) -> void: 
		health_bar.value = (player.get_node("HealthComponent") as HealthComponent).current_health
	)
	
	#set player icon
	match hero_name:
		"swordsman": 
			(player_icon.get_node("swordsman") as TextureRect).visible = true
			health_bar.max_value = 100.0
			health_bar.value = 100.0
		"knight": 
			(player_icon.get_node("knight") as TextureRect).visible = true
			health_bar.max_value = 125.0
			health_bar.value = 125.0
		"wizard": 
			(player_icon.get_node("wizard") as TextureRect).visible = true
			health_bar.max_value = 75.0
			health_bar.value = 75.0
	
	#set color and text for indicator label
	($BackgroundPanel as Panel).modulate = color
	player_indicator.modulate = color
	player_indicator.text = "P" + str(player_number + 1)


func trigger_cooldown(index: int, cooldown: float) -> void:
	ability_cooldown_timers[index].start(cooldown)
	(ability_icons[index].get_node("CooldownProgress") as ProgressBar).visible = true
	ability_on_cooldown[index] = true



func _on_ability_1_cooldown_timeout() -> void:
	(ability_icons[Ability.ABILITY_1].get_node("CooldownProgress") as ProgressBar).visible = false
	ability_on_cooldown[Ability.ABILITY_1] = false


func _on_ability_2_cooldown_timeout() -> void:
	(ability_icons[Ability.ABILITY_2].get_node("CooldownProgress") as ProgressBar).visible = false
	ability_on_cooldown[Ability.ABILITY_2] = false
