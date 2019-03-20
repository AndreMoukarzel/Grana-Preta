extends Control

# Declare member variables here. Examples:
# var a = 2
const OFFSET = Vector2(10, 5)

# Called when the node enters the scene tree for the first time.
func _ready():
	rect_size = OS.get_window_size() - OFFSET
	rect_position = OFFSET/2
