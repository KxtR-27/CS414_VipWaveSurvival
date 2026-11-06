class_name DialogueBox
extends PanelContainer
## a dialogue box meant to be used to make [BaseCharacter]s "say" something
##
## use static [method DialogueBox.create_dialogue_box] to create dialogue boxes,
## then add them to a child of the tree.
## see the static method for more information.


# making this a const inconsistently causes a parse error,
# as that way referencing itself creates a cyclical reference problem
static var THIS_SCENE := preload("res://ui_components/dialogue_box/dialogue_box.tscn")

var do_fade: bool = false

@onready var label := $Label as Label
@onready var lifetime := $Lifetime as Timer
@onready var fade_lifetime := $FadeLifetime as Timer


static func create_dialogue_box(
	dialogue: String, # required
	parent: Node2D, # must add dialogue box to tree to configure it
	max_width: float = 100.0, # px, used to wrap text
	lifetime_duration: float = 5.0, # seconds, non-negative please
	fade_duration: float = 0.0, # seconds, falsy, non-negative please
) -> DialogueBox:
	# instantiate
	var dialogue_box := THIS_SCENE.instantiate() as DialogueBox
	parent.add_child(dialogue_box)
	
	# clamp times
	var clamped_lifetime_duration := maxf(0.001, lifetime_duration)
	var clamped_fade_duration := maxf(0.001, fade_duration) # preserve falsy
	
	# configure
	dialogue_box.label.text = dialogue
	dialogue_box.label.custom_maximum_size.x = max_width
	dialogue_box.lifetime.wait_time = clamped_lifetime_duration
	dialogue_box.fade_lifetime.wait_time = clamped_fade_duration
	dialogue_box.do_fade = fade_duration <= 0
	
	return dialogue_box


#func _process(_delta: float) -> void:
	#if do_fade and not fade_lifetime.paused:
		#self.modulate.a = fade_lifetime.time_left / fade_lifetime.wait_time


func _on_lifetime_timeout() -> void:
	if do_fade:
		fade_lifetime.start()
	else:
		self.queue_free()


func _on_fade_lifetime_timeout() -> void:
	self.queue_free()
