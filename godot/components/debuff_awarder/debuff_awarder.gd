class_name DebuffAwarder extends Control

@export var debuffs: Node
@export var vip: BaseVIP
@export var debuff_menu_canvas_layer: CanvasLayer

const DEBUFFS_OPTION_POOL_SIZE: int = 2


func award_debuff() -> void:
	if vip:
		populate_debuff_menu()
		debuff_menu_canvas_layer.visible = true


func apply_debuff(debuff: Debuff) -> void:
	if vip:
		debuff.vip = vip
		debuff.reparent(vip.get_node("Debuffs"))
		debuff.debuff_activated.emit()
		print(debuff.name, " has been activated")


func populate_debuff_menu() -> void:
	var remaining_debuffs: Array[Node] = debuffs.get_children()
	var num_remaining_debuffs: int = remaining_debuffs.size()
	
	#2 or more debuffs remain!
	if num_remaining_debuffs >= DEBUFFS_OPTION_POOL_SIZE:
		#select a random number of debuffs equal to DEBUFFS_OPTION_POOL_SIZE
		var remaining_debuffs_copy: Array[Node] = remaining_debuffs.duplicate(true)
		var chosen_debuffs: Array[Debuff] = []
		
		for i in range(DEBUFFS_OPTION_POOL_SIZE):
			var random_debuff_index: int = randi_range(1, num_remaining_debuffs) - 1 - i
			var random_debuff: Debuff = remaining_debuffs_copy[random_debuff_index]
			
			chosen_debuffs.append(random_debuff)
			remaining_debuffs_copy.erase(random_debuff)
		
		#update the buttons to reflect the chosen debuffs
		var debuff_panel_1 := $DebuffMenu/Panel/VBoxContainer/DebuffPanelHBox/DebuffButtonPanel as DebuffButtonPanel
		var debuff_panel_2 := $DebuffMenu/Panel/VBoxContainer/DebuffPanelHBox/DebuffButtonPanel2 as DebuffButtonPanel
		
		debuff_panel_1.debuff = chosen_debuffs[0]
		debuff_panel_2.debuff = chosen_debuffs[1]
		
		debuff_panel_1.update_button_text()
		debuff_panel_2.update_button_text()
	
	elif num_remaining_debuffs > 0:
		#there are still debuffs available, but fewer than DEBUFFS_OPTION_POOL_SIZE
		var debuff_panel_1 := $DebuffMenu/Panel/VBoxContainer/DebuffPanelHBox/DebuffButtonPanel as DebuffButtonPanel
		var debuff_panel_2 := $DebuffMenu/Panel/VBoxContainer/DebuffPanelHBox/DebuffButtonPanel2 as DebuffButtonPanel
		
		debuff_panel_1.debuff = remaining_debuffs[0]
		
		debuff_panel_1.update_button_text()
		debuff_panel_2.queue_free()
	else:
		#oops! no more debuffs available
		print("no debuffs are available")
		debuff_menu_canvas_layer.visible = false


func _on_health_component_died() -> void:
	vip = null


func _on_debuff_button_panel_button_pressed(current_debuff: Debuff) -> void:
	apply_debuff(current_debuff)
	debuff_menu_canvas_layer.visible = false


func _on_debuff_button_panel_2_button_pressed(current_debuff: Debuff) -> void:
	apply_debuff(current_debuff)
	debuff_menu_canvas_layer.visible = false
