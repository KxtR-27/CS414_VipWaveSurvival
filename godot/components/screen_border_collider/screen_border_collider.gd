@tool
extends StaticBody2D
## via a few different methods, fits world boundaries to the """screen"""
##
## for characters/bodies that you want to collide with the wall, 
## add [b]layer 3[/b] to the characters'/bodies' [b]collision mask[/b].
## [br][br]
## affected bodies can enter onto the screen if outside its bounds,
## but affected bodies CANNOT leave the screen onside inside its bounds.


## the least reliable fit. this is the Godot window size.
## your height ends up being the height of your screen 
## - the window titlebar - your taskbar size,
## or your screen resolution if in fullscreen.
@export_tool_button("Fit to window\n(Like, your whole Godot window)", "FixedSize") \
	var fit_to_window := \
		func() -> void:
			var window_size := DisplayServer.window_get_size()
			_fit_to_rect(Rect2(0, 0, window_size.x, window_size.y))

## less reliable than [code]Fit to project settings[/code].
## for an unknown reason, this tends to be slightly larger.
@export_tool_button("Fit to viewport\n(Dynamic)", "SubViewport") \
	var fit_to_viewport := \
		func() -> void:
			var viewport_rect := get_viewport_rect()
			_fit_to_rect(viewport_rect)

## the most reliable fit. fits to the rectangle you see in the 2D viewport from the editor.
@export_tool_button("Fit to project settings\n(Recommended)", "AnimationAutoFitBezier") \
	var fit_to_settings := \
		func() -> void:
			var initial_size_x: int = ProjectSettings.get_setting("display/window/size/viewport_width")
			var initial_size_y: int = ProjectSettings.get_setting("display/window/size/viewport_height")
			_fit_to_rect(Rect2(0, 0, initial_size_x, initial_size_y))


@export_group("Custom Fit")
@export var custom_rect: Rect2
@export_tool_button("Fit to custom rect", "RectangleShape2D") \
	var fit_to_custom := \
		func() -> void:
			_fit_to_rect(custom_rect)


@onready var top_border := $TopBorder as CollisionShape2D
@onready var right_border := $RightBorder as CollisionShape2D
@onready var bottom_border := $BottomBorder as CollisionShape2D
@onready var left_border := $LeftBorder as CollisionShape2D


func _fit_to_rect(rect: Rect2) -> void:
	print(self.name, ": fitting borders to rect ", rect)
	
	var top_edge_middle := Vector2(rect.position.x + (rect.size.x / 2.0), rect.position.y)
	var right_edge_middle := Vector2(rect.position.x + rect.size.x, rect.position.y + (rect.size.y / 2.0))
	var bottom_edge_middle := Vector2(top_edge_middle.x, top_edge_middle.y + rect.size.y)
	var left_edge_middle := Vector2(rect.position.x, right_edge_middle.y)
	
	top_border.global_position = top_edge_middle
	right_border.global_position = right_edge_middle
	bottom_border.global_position = bottom_edge_middle
	left_border.global_position = left_edge_middle
