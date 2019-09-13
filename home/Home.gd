extends Control

const TWN_TIME = .5

var current_screen = "main"

func _ready():
	$Computer/SwipeHandler.deactivate()
	$Organizator/SwipeHandler.deactivate()
	$Organizator.hide_prediction()

func _on_HUD_on_Back_pressed():
	if current_screen == "main":
		var e = get_tree().change_scene("res://City.tscn")
		if e != 0:
			print("City scene couldn't be loaded")
	else:
		$Tween.interpolate_property($Computer, 'rect_position:x', null, -576, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Organizator, 'rect_position:x', null, 576, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Background/TextureRect, 'rect_position:x', null, -300, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Buttons, 'rect_position:x', null, 0, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()
		$HUD.set_city_texture()
		current_screen = "main"
		$Computer/SwipeHandler.deactivate()
		$Organizator/SwipeHandler.deactivate()
		$Organizator.hide_prediction()


func _on_Computer_pressed():
	$Tween.interpolate_property($Computer, 'rect_position:x', null, 0, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Background/TextureRect, 'rect_position:x', null, 0, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Buttons, 'rect_position:x', null, 576, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	$HUD.set_arrow_texture()
	current_screen = "computer"
	$Computer/SwipeHandler.activate()


func _on_Tracker_pressed():
	$Tween.interpolate_property($Organizator, 'rect_position:x', null, 0, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Background/TextureRect, 'rect_position:x', null, -900, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Buttons, 'rect_position:x', null, -576, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	$HUD.set_arrow_texture()
	current_screen = "organizator"
	$Organizator/SwipeHandler.activate()
	$Organizator.show_prediction()
