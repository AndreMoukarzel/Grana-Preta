extends Control

const TWN_TIME = 1

onready var SCREEN_SIZE = OS.get_window_size()

var on_main_menu = true

func _ready():
	$Background/Panel.rect_size = OS.get_screen_size()
	$Menu.rect_size = self.rect_size * 0.8
	$Menu.rect_position.y = self.rect_size.y * 0.2
	$Turtle.rect_position.x = self.rect_size.x * 0.8
	$InvestmentMenu.rect_position.x = 1.5 * SCREEN_SIZE.x
	$PortfolioMenu.rect_position.x = -1.5 * SCREEN_SIZE.x


func tween_menus(middle_position):
	$Tween.interpolate_property($Menu, "rect_position:x", null, middle_position, TWN_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($InvestmentMenu, "rect_position:x", null, middle_position + 1.5 * SCREEN_SIZE.x, TWN_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PortfolioMenu, "rect_position:x", null, middle_position - 1.5 * SCREEN_SIZE.x, TWN_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Investments_pressed():
	on_main_menu = false
	tween_menus(-1.5 * SCREEN_SIZE.x)


func _on_Portfolio_pressed():
	on_main_menu = false
	tween_menus(1.5 * SCREEN_SIZE.x)


func _on_Button_pressed():
	if on_main_menu:
		var e = get_tree().change_scene("res://City.tscn")
		if e != 0:
			print("City scene couldn't be loaded")
	else:
		tween_menus(0)
		on_main_menu = true
