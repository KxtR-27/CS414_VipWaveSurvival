@tool
class_name NavigableAtlasTexture
extends AtlasTexture


@export var element_size: Vector2i = Vector2i(64, 64):
	set(new_size):
		element_size = new_size
		self.region.size.x = element_size.x
		self.region.size.y = element_size.y

@export var current_position: Vector2i = Vector2i(0, 0):
	set(new_position):
		if (
				new_position.x < 0
				or new_position.y < 0
				or element_size.x * (new_position.x + 1) - 1 > atlas.get_width()
				or element_size.y * (new_position.y + 1) - 1 > atlas.get_height()
		):
			push_warning("Tried to navigate out of bounds")
			return
		else:
			current_position = new_position
			region.position.x = current_position.x * element_size.x
			region.position.y = current_position.y * element_size.y

@export_tool_button("Shift Up", "MoveUp") var move_up_btn: Callable = \
	func() -> void: current_position += Vector2i(0, -1)

@export_tool_button("Shift Right", "MoveRight") var move_right_btn: Callable = \
	func() -> void: current_position += Vector2i(1, 0)

@export_tool_button("Shift Left", "MoveLeft") var move_left_btn: Callable = \
	func() -> void: current_position += Vector2i(-1, 0)

@export_tool_button("Shift Down", "MoveDown") var move_down_btn: Callable = \
	func() -> void: current_position += Vector2i(0, 1)

@export_tool_button("Update", "Reload") var update_btn: Callable = \
	func() -> void: 
		element_size = Vector2i(element_size)
		current_position = Vector2i(current_position)
