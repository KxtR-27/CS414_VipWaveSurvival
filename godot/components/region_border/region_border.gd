@tool
class_name RegionBorder
extends StaticBody2D
## via a few different methods, fits world boundaries to the """screen"""
##
## for characters/bodies that you want to collide with the wall, 
## add [b]layer 3[/b] to the characters'/bodies' [b]collision mask[/b].
## [br][br]
## affected bodies can enter onto the screen if outside its bounds,
## but affected bodies CANNOT leave the screen onside inside its bounds.


@export_group("Presets")

## the least reliable fit. 
## this is the Godot window relative to your entire computer screen.
## your height ends up being the height of your screen 
## minus the window titlebar minus your taskbar height,
## or your complete screen resolution if in fullscreen.
@export_tool_button("Fit to window (Entire screen)", "FixedSize") \
	var window_fit_buttom: Callable = fit_to_window

## less reliable than [code]Fit to project settings[/code].
## for an unknown reason, this tends to be slightly larger.
@export_tool_button("Fit to viewport (Dynamic)", "SubViewport") \
	var viewport_fit_button: Callable = fit_to_viewport

## the most reliable fit. fits to the rectangle you see in the 2D viewport from the editor.
@export_tool_button("Fit to project viewport settings\n(Recommended)", "AnimationAutoFitBezier") \
	var project_fit_button: Callable = fit_to_project_settings


@export_group("Custom Fit")
@export var custom_rect: Rect2
@export_tool_button("Fit to custom rect", "RectangleShape2D") \
	var custom_fit_button: Callable = fit_to_custom


@export_group("Camera Fit")
@export var camera: Camera2D
@export var follow_camera: bool = false
@export_tool_button("Fit to camera", "Camera2D") \
	var camera_fit_buttom := func() -> void: pass


@onready var top_edge := $TopEdge as CollisionShape2D
@onready var right_edge := $RightEdge as CollisionShape2D
@onready var bottom_edge := $BottomEdge as CollisionShape2D
@onready var left_edge := $LeftEdge as CollisionShape2D


func _process(_delta: float) -> void:
	if follow_camera:
		fit_to_camera()


func fit_to_window() -> void:
	var window_size := DisplayServer.window_get_size()
	_fit_to_rect(Rect2(0, 0, window_size.x, window_size.y))


func fit_to_viewport() -> void:
	var viewport_rect := get_viewport_rect()
	_fit_to_rect(viewport_rect)


func fit_to_project_settings() -> void:
	var initial_size_x: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var initial_size_y: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	_fit_to_rect(Rect2(0, 0, initial_size_x, initial_size_y))


func fit_to_custom() -> void:
	_fit_to_rect(custom_rect)


func fit_to_camera() -> void:
	var camera_rect: Rect2 = get_viewport_rect() * camera.get_canvas_transform()
	_fit_to_rect(camera_rect)


func _fit_to_rect(rect: Rect2) -> void:
	print(self.name, ": fitting borders to rect ", rect)
	
	var top_edge_middle := Vector2(rect.position.x + (rect.size.x / 2.0), rect.position.y)
	var right_edge_middle := Vector2(rect.position.x + rect.size.x, rect.position.y + (rect.size.y / 2.0))
	var bottom_edge_middle := Vector2(top_edge_middle.x, top_edge_middle.y + rect.size.y)
	var left_edge_middle := Vector2(rect.position.x, right_edge_middle.y)
	
	top_edge.global_position = top_edge_middle
	right_edge.global_position = right_edge_middle
	bottom_edge.global_position = bottom_edge_middle
	left_edge.global_position = left_edge_middle
