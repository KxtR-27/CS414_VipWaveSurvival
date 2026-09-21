class_name DebuffButtonPanel extends CenterContainer

@export var debuff: Debuff
@export var button: Button

signal button_pressed(current_debuff: Debuff)

func update_button_text() -> void:
	if debuff:
		button.text = debuff.debuff_name + ": " + debuff.debuff_description


func clear_button_text() -> void:
	button.text = ""


func _on_button_pressed() -> void:
	button_pressed.emit(debuff)
