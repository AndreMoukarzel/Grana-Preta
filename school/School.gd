extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Background/TextureRect.rect_size = OS.get_screen_size()
