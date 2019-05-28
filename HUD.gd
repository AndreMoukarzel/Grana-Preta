extends CanvasLayer

signal on_Back_pressed


func set_arrow_texture():
	$Back.texture_normal = load("res://back_arrow.png")

func set_city_texture():
	$Back.texture_normal = load("res://city_icon.png")

func _on_Back_pressed():
	emit_signal("on_Back_pressed")
